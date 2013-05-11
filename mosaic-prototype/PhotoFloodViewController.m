//
//  PhotoFloodViewController.m
//  ExistTest
//
//  Created by Blake VanLandingham on 4/23/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import "PhotoFloodViewController.h"
#import "PhotoFloodView.h"

@implementation PhotoFloodViewController

- (void)loadView
{
    PhotoFloodView *view = [[PhotoFloodView alloc] initWithFrame:CGRectZero];
    [self setView:view];

    int counter = 0;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    while (counter < 250) {
        NSString *imageFile = [NSString stringWithFormat:@"%@/frame%d.jpg", [[NSBundle mainBundle] resourcePath], counter];
        [photos addObject:imageFile];
        counter++;
    }
    
    [view setPhotos:photos];
    [view start];
}

@end
