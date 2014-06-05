//
//  BIDImageCache.m
//  Twitter Client
//
//  Created by user on 6/4/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "BIDImageCache.h"
#import "BIDUtils.h"

@implementation BIDImageCache {
    NSCache *cache;
}

- (BIDImageCache*) init {
    
    if (self = [super init]) {
        cache = [NSCache new];
        cache.totalCostLimit = 10 * 1024 * 1024; //10MB
    }
    
    return self;
}

+ (BIDImageCache *) sharedCache {
    static BIDImageCache *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken , ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void) loadImageFromURL: (NSString *) url withBlock: (CallbackBlock) block {
    UIImage* image = [cache objectForKey:url];
    
    if (image) {
        block(image, YES);
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            UIImage *image = [BIDUtils imageFromPath:url];
            [cache setObject:image forKey:url];
            block(image, NO);
        });
    }
}

@end
