//
//  JBFVine.h
//  ReVine
//
//  Created by Jeremy Feld on 5/26/16.
//  Copyright © 2016 JBF. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JBFVine : NSObject

@property (nonatomic, strong) NSString *videoUrlString;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userAvatarUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, assign) NSUInteger loops;
@property (nonatomic, assign) NSUInteger likes;
@property (nonatomic, assign) NSUInteger comments;
@property (nonatomic, assign) NSUInteger reposts;
@property (nonatomic, strong) NSDictionary *jsonDictionary;

- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

@end
