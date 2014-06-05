//
//  BIDUser.h
//  Twitter Client
//
//  Created by user on 5/30/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIDUser : NSObject

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userScreenName;
@property (strong, nonatomic) UIImage *picture;

- (BIDUser *) initFromDictionary: (NSDictionary *) dictionary;

@end
