//
//  TimedAFImageRequestOperation.m
//  mosaic-prototype
//
//  Created by Blake VanLandingham on 7/20/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import "TimedAFImageRequestOperation.h"

@implementation TimedAFImageRequestOperation

@synthesize startTime;

- (void)start
{
    startTime = CACurrentMediaTime();
    [super start];
}

@end
