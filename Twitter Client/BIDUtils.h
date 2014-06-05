//
//  BIDUtils.h
//  Twitter Client
//
//  Created by user on 5/30/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "BIDTweet.h"
#import "BIDUser.h"

typedef void (^ RequestBlock)(NSArray *);

@interface BIDUtils : NSObject

+ (void) requestTimeline: (ACAccount *) twitterAccount withBlock: (RequestBlock) requestBlock;
+ (void) requestTimeline: (ACAccount *) twitterAccount afterTweet: (BIDTweet *) tweet withBlock: (RequestBlock) requestBlock;
+ (void) requestTimeline: (ACAccount *) twitterAccount sinceTweet: (BIDTweet *) tweet withBlock: (RequestBlock) requestBlock;

+ (UIImage *) imageFromPath:(NSString *)path;
+ (UIImage *) imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
