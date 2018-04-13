//
//  PDUIGratitudeViewController.h
//  Bolts
//
//  Created by Niall Quinn on 12/02/2018.
//

#import <UIKit/UIKit.h>
@class PDUIGratitudeView;
#import "PDReward.h"

typedef NS_ENUM(NSUInteger, PDGratitudeType) {
  PDGratitudeTypeConnect = 0,
  PDGratitudeTypeShare
};

@interface PDUIGratitudeViewController : UIViewController

@property (nonatomic, retain) PDUIGratitudeView *gratitudeView;
@property (nonatomic) PDGratitudeType type;
@property (nonatomic, retain) PDReward *reward;

- (id) initWithType:(PDGratitudeType)type;
- (id) initWithType:(PDGratitudeType)type reward:(PDReward*)reward;
- (void) dismissAction;
@end
