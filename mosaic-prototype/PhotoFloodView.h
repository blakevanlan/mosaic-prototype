//
//  PhotoFloodView.h
//  ExistTest
//
//  Created by Blake VanLandingham on 4/23/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface PhotoFloodView : UIView
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

@property (nonatomic, strong) NSArray *photos;

- (void)start;

@end
