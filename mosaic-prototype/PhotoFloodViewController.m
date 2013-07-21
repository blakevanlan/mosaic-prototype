//
//  PhotoFloodViewController.m
//  ExistTest
//
//  Created by Blake VanLandingham on 4/23/13.
//  Copyright (c) 2013 Blake VanLandingham. All rights reserved.
//

#import "PhotoFloodViewController.h"
#import "PhotoFloodView.h"
#import "AFImageRequestOperation.h"
#import "AFJSONRequestOperation.h"

@implementation PhotoFloodViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        [self fetchPhotoData];
    }
    
    return self;
}

- (void)loadView
{
    PhotoFloodView *view = [[PhotoFloodView alloc] initWithFrame:CGRectZero];
    [self setView:view];
}

- (void)fetchPhotoData
{
    NSURL *url = [NSURL URLWithString:@"http://mosaic-proto.herokuapp.com/images"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    typedef void(^SuccessBlock)(NSURLRequest *request, NSURLResponse *response, id JSON);
    
    SuccessBlock successBlock = ^(NSURLRequest *request, NSURLResponse *response, id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = JSON;
            photoFlood = [[PhotoFlood alloc] initWithArray:[result objectForKey:@"images"]];
            
            PhotoFloodView *view = (PhotoFloodView *)[self view];
            [photoFlood setDelegate:view];
            [view setPhotoFlood:photoFlood];
        }
    };
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:successBlock
                                                                                 failure:nil];
    [op start];
}

@end
