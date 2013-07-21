//
//  PhotoFlood.m
//  mosaic-prototype
//
//  Created by Blake VanLandingham on 5/27/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import "PhotoFlood.h"

@implementation PhotoFlood

@synthesize photos, averageLoadTime, numLoadedPhotos, delegate;

- (id)init
{
    return [self initWithArray:nil];
}

- (id)initWithArray:(NSArray *)arrayOfURLs
{
    self = [super init];
    
    if (self && arrayOfURLs) {
        // setup operation queue
        operationQueue = [NSOperationQueue new];
        [operationQueue setMaxConcurrentOperationCount:4];
        
        photos = [NSMutableArray arrayWithCapacity:[arrayOfURLs count]];
        
        // create operations
        for (NSString* url in arrayOfURLs)
        {
            Photo *photo = [[Photo alloc] initWithURL:[NSURL URLWithString:url]];
            [photo setDelegate:self];
            [operationQueue addOperation:[photo createDownloadPhotoOperation]];
            [photos addObject: photo];
        }
    }
    
    return self;
}

- (Photo *)photoAtIndex:(int)index
{
    return [photos objectAtIndex:index];
}

- (int)count
{
    return [photos count];
}

- (void)photoReady:(Photo *)photo
{
    sumLoadTime += [photo loadTime];
    averageLoadTime = sumLoadTime / ++numLoadedPhotos;
    [delegate photoReady:photo];
}

@end
