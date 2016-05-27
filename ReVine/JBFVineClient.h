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

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userKey;
@property (nonatomic, strong) NSString *avatarUrlString;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSMutableArray <JBFVine *> *userTimelineVines;
@property (nonatomic, strong) NSMutableArray <JBFVine *> *popularVines;
@property (nonatomic, strong) NSMutableString *nextPage;

+ (JBFVineClient *) sharedDataStore;
- (void)loginWithUserDictionary:(NSDictionary *)dictionary Completion:(void (^)(BOOL))loggedIn;
- (void)getPopularVinesWithCompletion:(void (^)(BOOL))completionBlock;
- (void)getPopularVinesForNextPage:(NSString *)page WithCompletion:(void (^)(BOOL))completionBlock;
- (void)getUserTimelineWithCompletion:(void (^)(BOOL))completionBlock;

@end