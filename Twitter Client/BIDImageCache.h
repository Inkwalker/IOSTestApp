//
//  BIDImageCache.h
//  Twitter Client
//
//  Created by user on 6/4/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ CallbackBlock)(UIImage *, BOOL);

@interface BIDImageCache : NSObject

+ (BIDImageCache *) sharedCache;

- (void) loadImageFromURL: (NSString *) url withBlock: (CallbackBlock) block;

@end
