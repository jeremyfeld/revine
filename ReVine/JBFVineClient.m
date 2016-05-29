//
//  JBFVineClient.m
//  ReVine
//
//  Created by Jeremy Feld on 5/26/16.
//  Copyright © 2016 JBF. All rights reserved.
//

#import "JBFVineClient.h"

@implementation JBFVineClient

+ (JBFVineClient *)sharedDataStore
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
            NSLog(@"oh shit");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // handle error
    }];
}

- (void)getPopularVinesWithCompletion:(void (^)(BOOL))completionBlock
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
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

- (void)getPopularVinesForNextPage:(NSString *)page WithCompletion:(void (^)(BOOL))completionBlock
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
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

- (void)getUserTimelineWithCompletion:(void (^)(BOOL))completionBlock;
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
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

//like
//POST https://api.vineapp.com/posts/xxxx/likes

/*   
 "like": {
 "endpoint": "posts/%s/likes",
 "request_type": "post",
 "url_params": ["post_id"],
 "required_params": [],
 "optional_params": [],
 "model": "Like"
 
 
 
 unlike
 "unlike": {
 "endpoint": "posts/%s/likes",
 "request_type": "delete",
 "url_params": ["post_id"],
 "required_params": [],
 "optional_params": [],
 
 */

//comment

//repost
//"revine": {
//    "endpoint": "posts/%s/repost",
//    "request_type": "post",
//    "url_params": ["post_id"],

@end
