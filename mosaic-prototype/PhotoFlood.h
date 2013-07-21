//
//  PhotoFlood.h
//  mosaic-prototype
//
//  Created by Blake VanLandingham on 5/27/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface PhotoFlood : NSObject
    <PhotoDelegate>
{
    NSOperationQueue *operationQueue;
    float sumLoadTime;
}

@property (nonatomic, readonly, strong) NSMutableArray *photos;
@property (nonatomic, readonly) float averageLoadTime;
@property (nonatomic, readonly) int numLoadedPhotos;
@property (nonatomic, weak) id delegate;

- (id)initWithArray:(NSArray *)arrayOfURLs;
- (int)count;
- (Photo *)photoAtIndex:(int)index;

@end


@protocol PhotoFloodDelegate <NSObject>

- (void)photoReady:(Photo *)photo;

@end