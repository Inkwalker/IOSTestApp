//
//  BIDUser.m
//  Twitter Client
//
//  Created by user on 5/30/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "BIDUser.h"
#import "BIDUtils.h"

@implementation BIDUser

- (BIDUser *) initFromDictionary: (NSDictionary *) dictionary {
    self = [self init];
    
    NSDictionary *userData = dictionary[@"user"];
    
    self.userName = userData[@"name"];
    self.userScreenName = userData[@"screen_name"];
    
    self.picture = [BIDUtils imageFromPath: userData[@"profile_image_url"]];
    
    return self;
}

@end
