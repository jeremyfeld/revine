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
@property (nonatomic, strong) NSString *username;

@end

@implementation JBFVineClient

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
        _userTimelineVines = [[NSMutableArray alloc] init];
        _popularVines = [[NSMutableArray alloc] init];
        _nextPage = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (void)loginWithUserParams:(NSDictionary *)dictionary completion:(void (^)(BOOL))loggedIn
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    
    [sessionManager POST:@"https://api.vineapp.com/users/authenticate" parameters:dictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        BOOL success = responseObject[@"success"];
        
        if (success) {
            self.userKey = responseObject[@"data"][@"key"];
            self.userID = responseObject[@"data"][@"userId"];
            self.username = responseObject[@"data"][@"username"];
            self.avatarUrlString = responseObject [@"data"][@"avatarUrl"];
            
            loggedIn(YES);
            
        } else {
            loggedIn(NO);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        loggedIn(NO);
    }];
}

- (void)getPopularVinesWithSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    [sessionManager GET:@"https://api.vineapp.com/timelines/popular" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        for (NSDictionary *vineDict in responseObject[@"data"][@"records"]) {
            
            if ([vineDict isKindOfClass:[NSDictionary class]]) {
                JBFVine *vine = [[JBFVine alloc] initWithDictionary:vineDict];
                
                [self.popularVines addObject:vine];
            }
        }
        
        self.nextPage = responseObject[@"data"][@"nextPage"];
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(NO);
    }];
}

- (void)getPopularVinesForNextPage:(NSString *)page withSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *nextPage = [NSString stringWithFormat:@"https://api.vineapp.com/timelines/popular?page=%@", self.nextPage];
    
    [sessionManager GET:nextPage parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        for (NSDictionary *vineDict in responseObject[@"data"][@"records"]) {
            
            if ([vineDict isKindOfClass:[NSDictionary class]]) {
                JBFVine *vine = [[JBFVine alloc] initWithDictionary:vineDict];
                
                [self.popularVines addObject:vine];
            }
        }
        
        self.nextPage = responseObject[@"data"][@"nextPage"];
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(NO);
    }];
}

- (void)getUserTimelineWithSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion;
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *userTimeline = [NSString stringWithFormat:@"https://api.vineapp.com/timelines/users/%@",self.userID];
    
    [sessionManager GET:userTimeline parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        for (NSDictionary *vineDict in responseObject[@"data"][@"records"]) {
            
            if ([vineDict isKindOfClass:[NSDictionary class]]) {
                JBFVine *vine = [[JBFVine alloc] initWithDictionary:vineDict];
                
                [self.userTimelineVines addObject:vine];
            }
        }
        
        self.nextPage = responseObject[@"data"][@"nextPage"];
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(NO);
    }];
}

- (void)likePost:(NSString *)postID withSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *postEndpoint = [NSString stringWithFormat:@"https://api.vineapp.com/posts/%@/likes", postID];
    
    [sessionManager POST:postEndpoint parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(NO);
    }];
}

- (void)unlikePost:(NSString *)postID withSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *postEndpoint = [NSString stringWithFormat:@"https://api.vineapp.com/posts/%@/likes", postID];
    
    [sessionManager DELETE:postEndpoint parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(NO);
    }];
}

- (void)repost:(NSString *)postID withSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *postEndpoint = [NSString stringWithFormat:@"https://api.vineapp.com/posts/%@/repost", postID];
    
    [sessionManager POST:postEndpoint parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(NO);
    }];
}

- (void)commentOnPost:(NSString *)postID withSessionID:(NSString *)sessionID withComment:(NSString *)commentString withCompletion:(void (^)(BOOL))completion
{
    
}

-(NSString *)currentUserKey
{
    return self.userKey;
}

@end
