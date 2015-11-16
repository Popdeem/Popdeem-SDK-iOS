//
//  LBMenuOption.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 16/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LBMenuOption : NSObject

@property (nonatomic, strong) NSString *viewControllerName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *iconImage;

- (id) initWithVCName:(NSString*)vcName imageName:(NSString*)imageName title:(NSString*)title;

@end
