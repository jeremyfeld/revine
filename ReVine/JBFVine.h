//
//  JBFVine.h
//  ReVine
//
//  Created by Jeremy Feld on 5/26/16.
//  Copyright © 2016 JBF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JBFVine : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) NSURL *userAvatarUrl;
@property (nonatomic, strong) NSURL *vineThumbnailUrl;
@property (nonatomic, strong) UIImage *userAvatarImage;
@property (nonatomic, strong) UIImage *vineThumbnailImage;
@property (nonatomic, assign) NSUInteger postID;
@property (nonatomic, assign) NSUInteger loops;
@property (nonatomic, assign) NSUInteger likes;
@property (nonatomic, assign) NSUInteger comments;
@property (nonatomic, assign) NSUInteger reposts;
@property (nonatomic, assign) BOOL userHasLiked;
@property (nonatomic, assign) BOOL userHasReposted;
@property (nonatomic, assign) BOOL userIsBlocked;
@property (nonatomic, strong) NSDictionary *jsonDictionary;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

@end
