//
//  BIDLoadMoreCell.m
//  Twitter Client
//
//  Created by user on 6/3/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "BIDLoadMoreCell.h"

@interface BIDLoadMoreCell ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;

@end


@implementation BIDLoadMoreCell

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

- (void) prepareForReuse {
    [_act startAnimating];
}

@end
