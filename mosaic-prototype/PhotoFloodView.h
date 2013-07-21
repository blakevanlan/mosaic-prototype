//
//  PhotoFloodView.h
//  ExistTest
//
//  Created by Blake VanLandingham on 4/23/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Photo.h"
#import "PhotoFlood.h"

@interface PhotoFloodView : UIView
    <PhotoDelegate>
{
    CALayer *photoLayer;
    CAShapeLayer *controlLayer;
    CAShapeLayer *sliderLayer;
    CAShapeLayer *rightButtonLayer;
    CAShapeLayer *leftButtonLayer;
    
    NSTimer *currentTimer;
    int currentImage;
    CGPoint touchLastChange;
}

extern const float PHOTO_VIEW_RATE;

@property (nonatomic, strong) PhotoFlood *photoFlood;
@property (nonatomic, readonly) BOOL isStarted;

- (void)start;

@end
