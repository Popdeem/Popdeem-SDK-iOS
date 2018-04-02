//
//  PDUIGratitudeViewController.h
//  Bolts
//
//  Created by Niall Quinn on 12/02/2018.
//

#import <UIKit/UIKit.h>
@class PDUIGratitudeView;

typedef NS_ENUM(NSUInteger, PDGratitudeType) {
  PDGratitudeTypeConnect = 0,
  PDGratitudeTypeShare
};

@interface PDUIGratitudeViewController : UIViewController

@property (nonatomic, retain) PDUIGratitudeView *gratitudeView;
@property (nonatomic) PDGratitudeType type;

- (id) initWithType:(PDGratitudeType)type;
- (void) dismissAction;
@end
