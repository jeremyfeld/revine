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
- (void)loginWithUserDictionary:(NSDictionary *)dictionary Completion:(void (^)(BOOL))loggedIn;
- (void)getPopularVinesWithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock;
- (void)getPopularVinesForNextPage:(NSString *)page WithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock;
- (void)getUserTimelineWithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock;
- (void)likePost:(NSString *)postID WithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock;
- (void)unlikePost:(NSString *)postID WithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock;
- (void)repost:(NSString *)postID WithSessionID:(NSString *)sessionID WithCompletion:(void (^)(BOOL))completionBlock;
- (void)commentOnPost:(NSString *)postID WithSessionID:(NSString *)sessionID WithComment:(NSString *)commentString WithCompletion:(void (^)(BOOL))completionBlock;
- (NSString *)returnUserKey;

@end