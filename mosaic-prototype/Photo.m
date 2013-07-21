//
//  Photo.m
//  mosaic-prototype
//
//  Created by Blake VanLandingham on 7/18/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@synthesize photoURL, filePath, loadTime;

- (id)init
{
    return [self initWithURL:nil];
}

- (id)initWithURL:(NSURL *)pURL
{
    self = [super init];
    
    if (self) {
        photoURL = pURL;
    }
    
    return self;
}

- (NSOperation *)createDownloadPhotoOperation
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[self photoURL]];
    
    loadOperation = [TimedAFImageRequestOperation
     imageRequestOperationWithRequest:request imageProcessingBlock:nil
     success:^(NSURLRequest *req, NSHTTPURLResponse *res, UIImage *image) {
         loadTime = CACurrentMediaTime() - [loadOperation startTime];
         NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString *dir = [directories objectAtIndex:0];
         filePath = [NSString stringWithFormat:@"%@/%@",dir, [self fileName]];
         
         // Save the image to disk
         NSData *imageData = UIImageJPEGRepresentation(image, 90);
         [imageData writeToFile:filePath atomically:YES];
         [[self delegate] photoReady:self];
     }
     failure:^(NSURLRequest *req, NSHTTPURLResponse *res, NSError *error) {
         NSLog(@"%@", [error localizedDescription]);
     }];
    
    return loadOperation;
}

- (NSString *)fileName
{
    return (NSString *)[[[self photoURL] pathComponents] lastObject];
}

@end
