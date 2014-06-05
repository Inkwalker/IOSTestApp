//
//  BIDTweetCell.h
//  Twitter Client
//
//  Created by user on 5/29/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDTweetCell : UITableViewCell

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *tweetText;

- (void) setPhotoImage: (UIImage *) image withAnimation: (BOOL) animate;
- (void) setUserImage: (UIImage *) image;

@end
