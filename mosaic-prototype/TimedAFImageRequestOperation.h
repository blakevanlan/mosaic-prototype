//
//  TimedAFImageRequestOperation.h
//  mosaic-prototype
//
//  Created by Blake VanLandingham on 7/20/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFImageRequestOperation.h"

@interface TimedAFImageRequestOperation : AFImageRequestOperation

@property (nonatomic, readonly) CFTimeInterval startTime;

@end
