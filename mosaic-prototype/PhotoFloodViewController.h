//
//  PhotoFloodViewController.h
//  ExistTest
//
//  Created by Blake VanLandingham on 4/23/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"
#import "PhotoFlood.h"

@interface PhotoFloodViewController : UIViewController
    <PhotoDelegate>
{
    PhotoFlood *photoFlood;
}

- (void)fetchPhotoData;
@end
