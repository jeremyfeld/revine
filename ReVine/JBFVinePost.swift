//
//  JBFVinePost.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/25/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import UIKit

class JBFVinePost: NSObject {

    var jsonDictionary: [String : String]
    
    init(jsonDictionary: [String: String]) {
        self.jsonDictionary = jsonDictionary
    }
    
}

/*
 
 var videoUrlString: String
 var username: String
 var userAvatarUrl: String
 var title: String
 var dateString: String
 var loops: Int
 var likes: Int
 var comments: Int
 var reposts: Int

 - (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary
 {
 self = [super init];
 
 if (self) {
 
 _jsonDictionary = jsonDictionary;
 _videoUrlString = jsonDictionary[@"videoUrl"];
 _videoUrl = [NSURL URLWithString:jsonDictionary[@"videoUrl"]];
 _username = jsonDictionary[@"username"];
 _userAvatarUrl = jsonDictionary[@"avatarUrl"];
 _title = jsonDictionary[@"description"];
 _dateString = jsonDictionary[@"created"];
 _loops = [jsonDictionary[@"loops"][@"count"] unsignedIntegerValue];
 _likes = [jsonDictionary[@"likes"][@"count"] unsignedIntegerValue];
 _comments = [jsonDictionary[@"comments"][@"count"] unsignedIntegerValue];
 _reposts = [jsonDictionary[@"reposts"][@"count"] unsignedIntegerValue];
 }
 
 return self;
 }

 */
