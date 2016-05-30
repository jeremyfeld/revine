//
//  JBFVine.m
//  ReVine
//
//  Created by Jeremy Feld on 5/26/16.
//  Copyright © 2016 JBF. All rights reserved.
//

#import "JBFVine.h"

@implementation JBFVine

- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    
    if (self) {
        
        _jsonDictionary = jsonDictionary;
        _videoUrl = [NSURL URLWithString:jsonDictionary[@"videoUrl"]];
        _username = jsonDictionary[@"username"];
        _postID = [NSString stringWithFormat:@"%@", jsonDictionary[@"postId"]];
        _userAvatarUrl = [NSURL URLWithString:jsonDictionary[@"avatarUrl"]];
        _vineThumbnailUrl = [NSURL URLWithString:jsonDictionary[@"thumbnailUrl"]];
        _title = jsonDictionary[@"description"];
        _dateString = jsonDictionary[@"created"];
        
        if ([jsonDictionary[@"loops"][@"count"] isKindOfClass:[NSNumber class]]) {
            
            _loops = [jsonDictionary[@"loops"][@"count"] unsignedIntegerValue];
            
        } else {
            
            _loops = 0;
        }
        
        if ([jsonDictionary[@"likes"][@"count"] isKindOfClass:[NSNumber class]]) {
            
            _likes = [jsonDictionary[@"likes"][@"count"] unsignedIntegerValue];
            
        } else {
            
            _likes = 0;
        }
        
        if ([jsonDictionary[@"comments"][@"count"] isKindOfClass:[NSNumber class]]) {
            
            _comments = [jsonDictionary[@"comments"][@"count"] unsignedIntegerValue];
            
        } else {
            
            _comments = 0;
        }
        
        if ([jsonDictionary[@"reposts"][@"count"] isKindOfClass:[NSNumber class]]) {
            
            _reposts = [jsonDictionary[@"reposts"][@"count"] unsignedIntegerValue];
            
        } else {
            
            _reposts = 0;
        }
   
        if ([jsonDictionary[@"liked"] isKindOfClass:[NSNumber class]]) {
            
            _userHasLiked = [jsonDictionary[@"liked"] boolValue];
            
        } else {
            
            _userHasLiked = nil;
        }
        
        if ([jsonDictionary[@"myRepostId"] isKindOfClass:[NSNumber class]]) {
            
            if ([jsonDictionary[@"myRepostId"] boolValue] == NO) {
                
                _userHasReposted = [jsonDictionary[@"myRepostId"] boolValue];
                
            } else {
                
                _userHasReposted = YES;
            }
            
        } else {
            
            _userHasReposted = nil;
        }
        
        if ([jsonDictionary[@"blocked"] isKindOfClass:[NSNumber class]]) {
            
            _userIsBlocked = [jsonDictionary[@"blocked"] boolValue];
            
        } else {
            _userIsBlocked = nil;
        }
    }
    
    return self;
}

@end
