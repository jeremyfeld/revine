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

- (void)getPopularVinesWithSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion;
- (void)getPopularVinesForNextPage:(NSString *)page withSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion;

- (void)getUserTimelineWithSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion;

- (void)likePost:(NSString *)postID withSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion;
- (void)unlikePost:(NSString *)postID withSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion;

- (void)repost:(NSString *)postID withSessionID:(NSString *)sessionID withCompletion:(void (^)(BOOL))completion;

- (void)commentOnPost:(NSString *)postID withSessionID:(NSString *)sessionID withComment:(NSString *)commentString withCompletion:(void (^)(BOOL))completion;

- (NSString *)currentUserKey;

@end