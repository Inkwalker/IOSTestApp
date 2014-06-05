//
//  BIDTweet.h
//  Twitter Client
//
//  Created by user on 5/29/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIDUser.h"

@interface BIDTweet : NSObject

@property (strong, nonatomic) BIDUser *user;

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *mediaUrl;
@property (copy, nonatomic) NSString *tweetId;

- (BIDTweet *) initFromDictionary: (NSDictionary *) dictionary;

@end
