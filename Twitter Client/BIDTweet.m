//
//  BIDTweet.m
//  Twitter Client
//
//  Created by user on 5/29/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "BIDTweet.h"
#import "BIDUtils.h"

@implementation BIDTweet

- (BIDTweet *) initFromDictionary: (NSDictionary *) dictionary {
    
    self = [self init];
    
    self.text = dictionary[@"text"];
    self.tweetId = dictionary[@"id_str"];
    
    NSDictionary *entities = dictionary[@"entities"];
    NSDictionary *user = dictionary[@"user"];
    NSArray *media = entities[@"media"];
    
    self.userId = user[@"id_str"];
    
    if ([media count] > 0) {
        NSDictionary *pic = [media objectAtIndex:0];
        _mediaUrl = pic[@"media_url"];

//        UIImage *image = [BIDUtils imageFromPath: pic[@"media_url"]];
//        self.media = [BIDUtils imageWithImage:image scaledToSize:CGSizeMake(329, 185)];
    }
    
    return self;
}

@end
