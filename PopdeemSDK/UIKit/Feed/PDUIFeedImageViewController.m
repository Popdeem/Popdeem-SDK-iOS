//
//  FeedImageViewController.m
//  Popdeem
//
//  Created by Niall Quinn on 06/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUIFeedImageViewController.h"
#import "PDUICheckinCell.h"

@implementation PDUIFeedImageViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    //Item should be set now
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImage *image = _item.actionImage;
    float imageWidth = self.view.frame.size.width;
    float imageHeight = self.view.bounds.size.height - 85;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    [self.imageView setBackgroundColor:[UIColor blackColor]];
    [self.imageView setImage:image];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.imageView.clipsToBounds = YES;
    [self.view addSubview:self.imageView];
    
    PDUICheckinCell *cell = [[PDUICheckinCell alloc] initWithFrame:CGRectMake(0, imageHeight, imageWidth, 75) forFeedItem:_item];
    [cell setFrame:CGRectMake(0, imageHeight+5, imageWidth, 75)];
    [self.view addSubview:cell];
    
    [self setTitle:[NSString stringWithFormat:@"%@'s Action",_item.userFirstName]];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    _item = nil;
    _imageView = nil;
}

@end
