//
//  JBFVineClient.h
//  ReVine
//
//  Created by Jeremy Feld on 5/26/16.
//  Copyright © 2016 JBF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "JBFVine.h"

@interface JBFVineClient : NSObject

@property (nonatomic, strong) NSMutableString *nextPage;

+ (JBFVineClient *) sharedClient;

- (void)loginWithUserParams:(NSDictionary *)dictionary completion:(void (^)(BOOL loggedIn, NSError *error))loggedIn;

- (void)getPopularVinesWithCompletion:(void (^)(NSArray <JBFVine *> *vines, NSError *error))completion;
- (void)getPopularVinesForNextPage:(NSString *)page withCompletion:(void (^)(NSArray <JBFVine *> *vines, NSError *error))completion;

- (void)getUserTimelineWithCompletion:(void (^)(NSArray <JBFVine *> *vines, NSError *error))completion;

- (void)likePost:(JBFVine *)vine withCompletion:(void (^)(BOOL))completion;
- (void)unlikePost:(JBFVine *)vine withCompletion:(void (^)(BOOL))completion;

- (void)repost:(JBFVine *)vine withCompletion:(void (^)(BOOL))completion;

- (void)commentOnPost:(JBFVine *)vine withComment:(NSString *)commentString withCompletion:(void (^)(BOOL))completion;

@end