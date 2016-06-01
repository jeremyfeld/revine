//
//  JBFVineClient.m
//  ReVine
//
//  Created by Jeremy Feld on 5/26/16.
//  Copyright © 2016 JBF. All rights reserved.
//

#import "JBFVineClient.h"

@interface JBFVineClient ()

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userKey;
@property (nonatomic, strong) NSString *avatarUrlString;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation JBFVineClient

static NSString *const VINE_API_BASE_URL = @"https://api.vineapp.com";

+ (JBFVineClient *)sharedClient
{
    static JBFVineClient *theInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        theInstance = [[JBFVineClient alloc] init];
    });
    
    return theInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _nextPage = [[NSMutableString alloc] init];
        _sessionManager = [AFHTTPSessionManager manager];
    }
    
    return self;
}

- (void)loginWithUserParams:(NSDictionary *)dictionary completion:(void (^)(BOOL loggedIn, NSError *error))loggedIn
{
    self.sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    
    [self.sessionManager POST:[NSString stringWithFormat:@"%@/users/authenticate", VINE_API_BASE_URL] parameters:dictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        BOOL success = responseObject[@"success"];
        
        if (success) {
            self.userKey = responseObject[@"data"][@"key"];
            self.userID = responseObject[@"data"][@"userId"];
            self.avatarUrlString = responseObject [@"data"][@"avatarUrl"];
            
            loggedIn(YES, nil);
            
        } else {
            loggedIn(NO, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        loggedIn(NO, error);
    }];
}

- (void)getPopularVinesWithCompletion:(void (^)(NSArray <JBFVine *> *vines, NSError *error))completion
{
    [self setJSONSerializerAndUserKey];
    
    [self.sessionManager GET:[NSString stringWithFormat:@"%@/timelines/popular", VINE_API_BASE_URL] parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *vines = [[NSMutableArray alloc] init];
        for (NSDictionary *vineDict in responseObject[@"data"][@"records"]) {
            
            if ([vineDict isKindOfClass:[NSDictionary class]]) {
                JBFVine *vine = [[JBFVine alloc] initWithDictionary:vineDict];
                
                if (vine) {
                    [vines addObject:vine];
                }
            }
        }
        
        self.nextPage = responseObject[@"data"][@"nextPage"];
        
        completion(vines, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completion(nil, error);
    }];
}

- (void)getPopularVinesForNextPage:(NSString *)page withCompletion:(void (^)(NSArray <JBFVine *> *vines, NSError *error))completion
{
    [self setJSONSerializerAndUserKey];
    
    [self.sessionManager GET:[NSString stringWithFormat:@"%@/timelines/popular?page=%@", VINE_API_BASE_URL, self.nextPage] parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *vines = [[NSMutableArray alloc] init];
        for (NSDictionary *vineDict in responseObject[@"data"][@"records"]) {
            
            if ([vineDict isKindOfClass:[NSDictionary class]]) {
                JBFVine *vine = [[JBFVine alloc] initWithDictionary:vineDict];
                
                if (vine) {
                    [vines addObject:vine];
                }
            }
        }
        
        self.nextPage = responseObject[@"data"][@"nextPage"];
        
        completion(vines, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completion(nil, error);
    }];
}

- (void)getUserTimelineWithCompletion:(void (^)(NSArray <JBFVine *> *vines, NSError *error))completion;
{
    [self setJSONSerializerAndUserKey];
    
    [self.sessionManager GET:[NSString stringWithFormat:@"%@/timelines/users/%@", VINE_API_BASE_URL, self.userID] parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *vines = [[NSMutableArray alloc] init];
        for (NSDictionary *vineDict in responseObject[@"data"][@"records"]) {
            
            if ([vineDict isKindOfClass:[NSDictionary class]]) {
                JBFVine *vine = [[JBFVine alloc] initWithDictionary:vineDict];
                
                if (vine) {
                    [vines addObject:vine];
                }
            }
        }
        
        self.nextPage = responseObject[@"data"][@"nextPage"];
        
        completion(vines, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completion(nil, error);
    }];
}

- (void)likePost:(JBFVine *)vine withCompletion:(void (^)(BOOL))completion
{
    [self setJSONSerializerAndUserKey];
    
    [self.sessionManager POST:[NSString stringWithFormat:@"%@/posts/%@/likes", VINE_API_BASE_URL, [self postIDForVine:vine]] parameters:nil progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completion(NO);
    }];
}

- (void)unlikePost:(JBFVine *)vine withCompletion:(void (^)(BOOL))completion
{
    [self setJSONSerializerAndUserKey];
    
    [self.sessionManager DELETE:[NSString stringWithFormat:@"%@/posts/%@/likes", VINE_API_BASE_URL, [self postIDForVine:vine]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completion(NO);
    }];
}

- (void)repost:(JBFVine *)vine withCompletion:(void (^)(BOOL))completion
{
    [self setJSONSerializerAndUserKey];
    
    [self.sessionManager POST:[NSString stringWithFormat:@"%@/posts/%@/repost", VINE_API_BASE_URL, [self postIDForVine:vine]] parameters:nil progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completion(NO);
    }];
}

- (void)commentOnPost:(JBFVine *)vine withComment:(NSString *)commentString withCompletion:(void (^)(BOOL))completion
{
    
}

- (void)setJSONSerializerAndUserKey
{
    self.sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [self.sessionManager.requestSerializer setValue:self.userKey forHTTPHeaderField:@"vine-session-id"];
}

- (NSString *)postIDForVine:(JBFVine *)vine
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)vine.postID];
}

@end
