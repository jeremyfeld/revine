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

- (void)loginWithUserDictionary:(NSDictionary *)dictionary
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

            [self getPopularVinesWithCompletion:^(BOOL timelineFetched) {
                if (timelineFetched) {
                    
                    NSLog(@"successfully fetched timeline");
                    NSLog(@"got first timeline, next page is: %@", self.nextPage);
                    [self getPopularVinesForNextPage:self.nextPage WithCompletion:^(BOOL fetched) {
                        if (fetched) {
                        NSLog(@"SECOND FETCH: %@", self.nextPage);
                            NSLog(@"DONE WITH SECOND FETCH do we have 39: %lu", self.popularVines.count);
                        }
                    }];
                    
                } else {
                    
                }
            }];
        } else {
            NSLog(@"oh shit");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // handle error
    }];
}

- (void)getPopularVinesWithCompletion:(void (^)(BOOL))completionBlock
{
    //    https://api.vineapp.com/timelines/popular
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET:@"https://api.vineapp.com/timelines/popular" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject for popular vines %@ \n\n\n\n\n", responseObject);
        for (NSDictionary *dictionary in responseObject[@"data"][@"records"]) {
            [self.popularVines addObject:dictionary];
        }
//        self.popularVines = responseObject[@"data"][@"records"];
        self.nextPage = responseObject[@"data"][@"nextPage"];

        NSLog(@"vine count: %lu", self.popularVines.count);
        
        completionBlock(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed: %@", error.localizedDescription);
        //present an error alert
        //
    }];
}

- (void)getPopularVinesForNextPage:(NSString *)page WithCompletion:(void (^)(BOOL))completionBlock
{
    //    https://api.vineapp.com/timelines/popular
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSString *nextPage = [NSString stringWithFormat:@"https://api.vineapp.com/timelines/popular?page=%@", self.nextPage];
    [sessionManager GET:nextPage parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject for popular vines 2nd go %@ \n\n\n\n\n", responseObject);
        
        
        self.nextPage = responseObject[@"data"][@"nextPage"];
        

        
        NSArray *pageTwoArray = responseObject[@"data"][@"records"];
        NSLog(@"PAGE TWO ARRAY IS HOW MANY???? %lu", pageTwoArray.count);
        
        for (NSDictionary *record in responseObject[@"data"][@"records"]) {
            [self.popularVines addObject:record];
        }
        
        NSLog(@"vine count: %lu", self.popularVines.count);
        completionBlock(YES);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed: %@", error.localizedDescription);
        //present an error alert
        //
    }];
}

- (void)getUserTimelineWithCompletion:(void (^)(BOOL))completionBlock;
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];

    NSString *userTimeline = [NSString stringWithFormat:@"https://api.vineapp.com/timelines/users/%@",self.userID];
    NSLog(@"%@", userTimeline);
    [sessionManager GET:userTimeline parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"self.userID IN GET TIMELINE %@", self.userID);
        NSLog(@"USER TIMELINE: %@", responseObject);
        
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        completionBlock(NO);
    }];
}


@end
