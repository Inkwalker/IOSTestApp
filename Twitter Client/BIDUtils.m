//
//  BIDUtils.m
//  Twitter Client
//
//  Created by user on 5/30/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "BIDUtils.h"

@implementation BIDUtils

+ (void) requestTimeline: (ACAccount *) twitterAccount withBlock: (RequestBlock) requestBlock {
    NSDictionary *parameters = @{@"count" : @"20"};

    [BIDUtils requestTimeline:twitterAccount withParams:parameters withBlock:requestBlock];
}

+ (void) requestTimeline: (ACAccount *) twitterAccount afterTweet: (BIDTweet *) tweet withBlock: (RequestBlock) requestBlock {
    NSDictionary *parameters =
    @{@"count" : @"20",
      @"max_id": tweet.tweetId};
    
    [BIDUtils requestTimeline:twitterAccount withParams:parameters withBlock:requestBlock];
}

+ (void) requestTimeline: (ACAccount *) twitterAccount sinceTweet: (BIDTweet *) tweet withBlock: (RequestBlock) requestBlock {
    NSDictionary *parameters =
    @{@"count" : @"20",
      @"since_id": tweet.tweetId};
    
    [BIDUtils requestTimeline:twitterAccount withParams:parameters withBlock:requestBlock];
}

+ (void) requestTimeline: (ACAccount *) twitterAccount withParams:(NSDictionary *) params withBlock: (RequestBlock) requestBlock {
    NSURL *requestURL = [NSURL URLWithString: @"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodGET
                              URL:requestURL parameters:params];
    
    postRequest.account = twitterAccount;
    
    [postRequest performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse
       *urlResponse, NSError *error)
     {
         NSArray *data = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:NSJSONReadingMutableLeaves
                          error:&error];
         
         requestBlock(data);
     }];
    
}

+ (UIImage *) imageFromPath:(NSString *)path {
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [[UIImage alloc] initWithData:data];
}

+ (UIImage *) imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    CGFloat scale = newSize.height / image.size.height;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scale, newSize.height), NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * scale, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
