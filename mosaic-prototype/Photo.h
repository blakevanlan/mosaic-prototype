//
//  Photo.h
//  mosaic-prototype
//
//  Created by Blake VanLandingham on 7/18/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimedAFImageRequestOperation.h"


@interface Photo : NSObject
{
    TimedAFImageRequestOperation *loadOperation;
}

@property (nonatomic, readonly, strong) NSURL *photoURL;
@property (nonatomic, readonly, strong) NSString *filePath;
@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) float loadTime;

- (id)initWithURL:(NSURL *)photoUrl;
- (NSString *)fileName;
- (NSOperation *)createDownloadPhotoOperation;

@end

@protocol PhotoDelegate <NSObject>

@optional

- (void)photoReady:(Photo *)photo;

@end