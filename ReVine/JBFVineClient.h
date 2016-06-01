//
//  JBFVineClient.h
//  ReVine
//
//  Created by Jeremy Feld on 5/26/16.
//  Copyright © 2016 JBF. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>
#import "JBFVine.h"

@interface JBFVineClient : NSObject

@property (nonatomic, strong) NSMutableArray <JBFVine *> *userTimelineVines;
@property (nonatomic, strong) NSMutableArray <JBFVine *> *popularVines;
@property (nonatomic, strong) NSMutableString *nextPage;

+ (JBFVineClient *) sharedClient;

- (void)loginWithUserParams:(NSDictionary *)dictionary completion:(void (^)(BOOL))loggedIn;

- (void)getPopularVinesWithCompletion:(void (^)(BOOL))completion;
- (void)getPopularVinesForNextPage:(NSString *)page withCompletion:(void (^)(BOOL))completion;

- (void)getUserTimelineWithCompletion:(void (^)(BOOL))completion;

- (void)likePost:(JBFVine *)vine withCompletion:(void (^)(BOOL))completion;
- (void)unlikePost:(JBFVine *)vine withCompletion:(void (^)(BOOL))completion;

- (void)repost:(JBFVine *)vine withCompletion:(void (^)(BOOL))completion;

- (void)commentOnPost:(JBFVine *)vine withComment:(NSString *)commentString withCompletion:(void (^)(BOOL))completion;

@end