//
//  PhotoFloodView.m
//  ExistTest
//
//  Created by Blake VanLandingham on 4/23/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import "PhotoFloodView.h"

@implementation PhotoFloodView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        
        photoLayer = [[CALayer alloc] init];
        [photoLayer setBounds:CGRectMake(0.0, 0.0, 306.0, 306.0)];
        [photoLayer setPosition:CGPointMake(160.0, 153.0)];
        
        [[self layer] addSublayer:photoLayer];
        [self setupControls];
        [self setupButtons];
        
        currentImage = -1;
    }
    return self;
}

- (void)setupControls
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath setLineCapStyle:kCGLineCapRound];
    [linePath moveToPoint:CGPointMake(0.0, 10.0)];
    [linePath addLineToPoint:CGPointMake(306.0, 10.0)];
    [linePath closePath];
    
    controlLayer = [[CAShapeLayer alloc] init];
    [controlLayer setBounds:CGRectMake(0.0, 0.0, 306.0, 40.0)];
    [controlLayer setPosition:CGPointMake(160.0, 330.0)];
    [controlLayer setZPosition:2.0];
    
    [controlLayer setPath:[linePath CGPath]];
    [controlLayer setLineWidth:1];
    [controlLayer setStrokeColor:[[[UIColor alloc] initWithWhite:1.0 alpha:0.6] CGColor]];
    [controlLayer setMasksToBounds:YES];
    
    
    CGRect rect = CGRectMake(0.0, 0.0, 8.0, 20.0);
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    sliderLayer = [[CAShapeLayer alloc] init];
    [sliderLayer setBounds:rect];
    [sliderLayer setPosition:CGPointMake(4.0, 10.0)];
    [sliderLayer setPath: [ovalPath CGPath]];
    [sliderLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    [[self layer] addSublayer:controlLayer];
    [controlLayer addSublayer:sliderLayer];
}

- (void)setupButtons
{
    leftButtonLayer = [[CAShapeLayer alloc] init];
    rightButtonLayer = [[CAShapeLayer alloc] init];
    
    CGRect bounds = CGRectMake(0.0, 0.0, 60.0, 60.0);
    UIBezierPath *initial = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(30.0, 30.0, 0.0, 0.0)];
//    UIBezierPath *initial = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(18.0, 18.0, 24.0, 24.0)];
    
    
    [leftButtonLayer setPath:[initial CGPath]];
    [leftButtonLayer setStrokeColor:[[UIColor redColor] CGColor]];
    [leftButtonLayer setFillColor:[[UIColor clearColor] CGColor]];
    [leftButtonLayer setPosition:CGPointMake(bounds.size.width/2 + 7.0, bounds.size.width/2)];
    [leftButtonLayer setBounds:bounds];
    
    [rightButtonLayer setPath:[initial CGPath]];
    [rightButtonLayer setStrokeColor:[[UIColor greenColor] CGColor]];
    [rightButtonLayer setFillColor:[[UIColor clearColor] CGColor]];
    [rightButtonLayer setPosition:CGPointMake(313.0-bounds.size.width/2, bounds.size.width/2)];
    [rightButtonLayer setBounds:bounds];

    //    [circle applyTransform:[CGAffineTransformMakeScale(2.0, 2.0)]];
    [leftButtonLayer setZPosition:2.0];
    [rightButtonLayer setZPosition:2.0];
    [[self layer] addSublayer:leftButtonLayer];
    [[self layer] addSublayer:rightButtonLayer];
    
    [self showButtons];
}

- (void)start
{
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                     target:self
                                   selector:@selector(nextTick:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)stop
{
    [currentTimer invalidate];
}

- (void)nextTick:(NSTimer *)timer
{
    [self nextImage:1];
    if (currentImage == [[self photos] count] - 1) {
        [self stop];
    }
}

- (void)nextImage:(int)amount
{
    [self showImage:currentImage + amount];
}

- (void)previousImage:(int)amount
{
    [self showImage:currentImage - amount];
}

- (void)showImage:(int)index
{
    if (index < 0) index = 0;
    else if (index >= [[self photos] count]) index = [[self photos] count] - 1;
    
    // create a UIImage
    UIImage *layerImage = [UIImage imageWithContentsOfFile:[[self photos] objectAtIndex:index]];
    
    // get the underlying CGImage
    CGImageRef image = [layerImage CGImage];
    
    
    int sliderWidth = [sliderLayer bounds].size.width;
    double available = [controlLayer bounds].size.width - sliderWidth;
    double percent = (double)index / [[self photos] count];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    // put the CGImage on the layer
    [photoLayer setContents:(__bridge id)image];
    
    // let the image resize (without changing the aspect ratio) to fill the contentRect
    [photoLayer setContentsGravity:kCAGravityResizeAspect];
    
    [sliderLayer setPosition:CGPointMake(available * percent + sliderWidth/2, [sliderLayer bounds].size.height/2)];

    [CATransaction commit];
    
    currentImage = index;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stop];
    
    for (UITouch *t in touches) {
        touchLastChange = [t locationInView:self];

        if ([self isInsideSlider:touchLastChange]) {
            [self setImageFromSliderPosition:touchLastChange];
        }
//        else {
//            [self previousImage:1];
//        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Create pentagon to allow user to actually use controls
    CGPoint leftCorner = CGPointMake(0.0, 0.0);
    CGPoint leftSide = CGPointMake(0.0, 100.0);
    CGPoint rightCorner = CGPointMake([self frame].size.width, 0.0);
    CGPoint rightSide = CGPointMake([self frame].size.width, 100.0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:touchLastChange];
    [path addLineToPoint:rightSide];
    [path addLineToPoint:rightCorner];
    [path addLineToPoint:leftCorner];
    [path addLineToPoint:leftSide];
    [path addLineToPoint:touchLastChange];
    
    for (UITouch *t in touches) {
        CGPoint loc = [t locationInView:self];
       
        if ([path containsPoint:loc]) return;
        else if ([self isInsideSlider:loc]) [self setImageFromSliderPosition:loc];
        else [self setImageFromChange:loc];
            
        break; // only use the first touch event, sloppy I know
    }
}

- (void)showButtons
{
//    UIBezierPath *start = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(30.0, 30.0, 0.0, 0.0)];
//    UIBezierPath *stop = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(18.0, 18.0, 24.0, 24.0)];
    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = (id)[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(18.0, 18.0, 24.0, 24.0)] CGPath];
    animation.delegate = self;
    animation.duration = 0.1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
//    [animation setValues:[NSArray arrayWithObjects:
//                          [UIBezierPath bezierPathWithOvalInRect:CGRectMake(15.0, 15.0, 30.0, 30.0)],
//                          [UIBezierPath bezierPathWithOvalInRect:CGRectMake(18.0, 18.0, 24.0, 24.0)],
//                          nil]];
    
    [leftButtonLayer addAnimation:animation forKey:@"animatePath"];
    [rightButtonLayer addAnimation:animation forKey:@"animatePath"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    CAKeyframeAnimation *keyframeAnim = (CAKeyframeAnimation *)anim;
    CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
    
    [leftButtonLayer setPath:(CGPathRef)basicAnim.toValue];
    [rightButtonLayer setPath:(CGPathRef)basicAnim.toValue];
}



//- (void)hideButtons
//{
//    UIBezierPath *start = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(18.0, 18.0, 24.0, 24.0)];
//    UIBezierPath *stop = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(30.0, 30.0, 0.0, 0.0)];
//    
//}

- (BOOL)isInsideSlider:(CGPoint) loc
{
    CGRect rect = [controlLayer frame];
    return (loc.x >= rect.origin.x &&
            loc.x <= rect.origin.x + rect.size.width &&
            loc.y >= rect.origin.y &&
            loc.y <= rect.origin.y + rect.size.height);
}

- (void)setImageFromSliderPosition:(CGPoint) loc
{
    int sliderWidth = [sliderLayer bounds].size.width;
    double available = [controlLayer bounds].size.width - sliderWidth;
    float x = loc.x - [controlLayer frame].origin.x - sliderWidth / 2;
    
    if (x < 0) x = 0.0;
    else if (x > available) x = available;
    
    [self showImage: (int)round([[self photos] count] * x / available)];
    touchLastChange = loc;
}

- (void)setImageFromChange:(CGPoint) loc
{
    double distanceRequired = 25.0;
    
    // moved to the left
    if (touchLastChange.x > loc.x) {
        double distance = touchLastChange.x - loc.x;
        int photosMoved = floor(distance / distanceRequired);
        if (photosMoved > 0) {
            touchLastChange = loc;
            [self previousImage:photosMoved];
        }
    }
    // moved to the right
    else if (touchLastChange.x < loc.x) {
        double distance = loc.x - touchLastChange.x;
        int photosMoved = floor(distance / distanceRequired);
        if (photosMoved > 0) {
            touchLastChange = loc;
            [self nextImage:photosMoved];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self start];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self start];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
