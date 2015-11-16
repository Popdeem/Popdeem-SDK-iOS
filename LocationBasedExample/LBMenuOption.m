//
//  LBMenuOption.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 16/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "LBMenuOption.h"

@implementation LBMenuOption

- (id) initWithVCName:(NSString*)vcName imageName:(NSString*)imageName title:(NSString*)title {
    if (self = [super init]) {
        self.viewControllerName = vcName;
        self.iconImage = [UIImage imageNamed:imageName];
        self.title = title;
        return self;
    }
    return nil;
}
@end
