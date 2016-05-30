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
        _postID = [NSString stringWithFormat:@"%@", jsonDictionary[@"postId"] ];
        _userAvatarUrl = [NSURL URLWithString:jsonDictionary[@"avatarUrl"]];
        _vineThumbnailUrl = [NSURL URLWithString:jsonDictionary[@"thumbnailUrl"]];
        _title = jsonDictionary[@"description"];
        _dateString = jsonDictionary[@"created"];
        _loops = [jsonDictionary[@"loops"][@"count"] unsignedIntegerValue];
        _likes = [jsonDictionary[@"likes"][@"count"] unsignedIntegerValue];
        _comments = [jsonDictionary[@"comments"][@"count"] unsignedIntegerValue];
        _reposts = [jsonDictionary[@"reposts"][@"count"] unsignedIntegerValue];
        _userAvatarImage = [UIImage imageNamed:@"vine v"];
        _userHasLiked = [jsonDictionary[@"liked"] boolValue];
        _userHasReposted = [jsonDictionary[@"myRepostId"] boolValue];
        _userIsBlocked = [jsonDictionary[@"blocked"] boolValue];;
    }
    
    return self;
}

@end
