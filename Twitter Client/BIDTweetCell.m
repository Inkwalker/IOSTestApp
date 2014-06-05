//
//  BIDTweetCell.m
//  Twitter Client
//
//  Created by user on 5/29/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "BIDTweetCell.h"

@interface BIDTweetCell()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
@property (strong, nonatomic) IBOutlet UIImageView *mediaImage;
@property (strong, nonatomic) IBOutlet UIImageView *userPic;

@end

@implementation BIDTweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setUserName:(NSString *)userName {
    if (![userName isEqualToString:_userName]) {
        _userName = [userName copy];
        self.nameLabel.text = _userName;
    }

}

- (void) setTweetText:(NSString *)tweetText {
    if (![tweetText isEqualToString:_tweetText]) {
        _tweetText = [tweetText copy];
        self.tweetTextView.text = _tweetText;
    }
}

- (void) setUserImage:(UIImage *)image {
    self.userPic.image = image;
}

- (void) setPhotoImage:(UIImage *)image withAnimation: (BOOL) animate {

    if (animate || (image != nil)) {
        [UIView transitionWithView:self.mediaImage duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.mediaImage.image = image;
        } completion:nil];
    } else {
        self.mediaImage.image = image;
    }
}

@end
