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

- (void)loginWithUserDictionary:(NSDictionary *)dictionary Completion:(void (^)(BOOL))loggedIn
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    
    [sessionManager POST:@"https://api.vineapp.com/users/authenticate" parameters:dictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        //
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
            NSLog(@"error");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // handle error
    }];
}

- (void)getPopularVinesWithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    [sessionManager GET:@"https://api.vineapp.com/timelines/popular" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"RESPONSE: %@", responseObject);
        
        for (NSDictionary *vineDict in responseObject[@"data"][@"records"]) {
            
            JBFVine *vine = [[JBFVine alloc] initWithDictionary:vineDict];
            
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    vine.userAvatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:vine.userAvatarUrl]];
                }];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    vine.vineThumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:vine.vineThumbnailUrl]];
                }];

            [self.popularVines addObject:vine];
        }
        
        self.nextPage = responseObject[@"data"][@"nextPage"];
        
        completionBlock(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //present an error alert
    }];
}

- (void)getPopularVinesForNextPage:(NSString *)page WithSessionID:(NSString *)sessionID  WithCompletion:(void (^)(BOOL))completionBlock
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *nextPage = [NSString stringWithFormat:@"https://api.vineapp.com/timelines/popular?page=%@", self.nextPage];
    
    [sessionManager GET:nextPage parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        for (NSDictionary *vineDict in responseObject[@"data"][@"records"]) {
            
            JBFVine *vine = [[JBFVine alloc] initWithDictionary:vineDict];
            
            [self.popularVines addObject:vine];
        }
        
        self.nextPage = responseObject[@"data"][@"nextPage"];
        
        completionBlock(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failed: %@", error.localizedDescription);
        //present an error alert
    }];
}

- (void)getUserTimelineWithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock;
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *userTimeline = [NSString stringWithFormat:@"https://api.vineapp.com/timelines/users/%@",self.userID];
    
    [sessionManager GET:userTimeline parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"USER TIMELINE: %@", responseObject);
        
        completionBlock(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //
        completionBlock(NO);
    }];
}

- (void)likePost:(NSString *)postID WithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *postEndpoint = [NSString stringWithFormat:@"https://api.vineapp.com/posts/%@/likes", postID];
    
    [sessionManager POST:postEndpoint parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        completionBlock(NO);
    }];
}

- (void)unlikePost:(NSString *)postID WithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *postEndpoint = [NSString stringWithFormat:@"https://api.vineapp.com/posts/%@/likes", postID];
    
    [sessionManager DELETE:postEndpoint parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        completionBlock(NO);
    }];
}

- (void)repost:(NSString *)postID WithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"vine-session-id"];
    
    NSString *postEndpoint = [NSString stringWithFormat:@"https://api.vineapp.com/posts/%@/repost", postID];
    
    [sessionManager POST:postEndpoint parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        completionBlock(NO);
    }];
}

- (void)commentOnPost:(NSString *)postID WithSessionID:(NSString *)sessionID WithComment:(NSString *)commentString WithCompletion:(void (^)(BOOL))completionBlock
{

}

-(NSString *)returnUserKey
{
    return self.userKey;
}

@end
