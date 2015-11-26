//
//  RewardTableViewCell.m
//  Popdeem
//
//  Created by Niall Quinn on 08/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "RewardTableViewCell.h"
#import "PDUser.h"

@implementation RewardTableViewCell

- (id) initWithFrame:(CGRect)frame reward:(PDReward*)reward {
    if (self = [super initWithFrame:frame]){
        
        self.frame = frame;
        BOOL rules = reward.rewardRules.length > 0;
        
        self.reward = reward;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.separatorInset = UIEdgeInsetsZero;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        float imageSize = 40;
        float indent = 10;
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(indent, 2*indent, imageSize, imageSize)];
        if (reward.coverImage) {
            [_logoImageView setImage:reward.coverImage];
        } else {
            [_logoImageView setImage:[UIImage imageNamed:@"starG"]];
        }
        [_logoImageView setContentMode:UIViewContentModeScaleAspectFit];
        _logoImageView.layer.cornerRadius = imageSize/2;
        _logoImageView.clipsToBounds = YES;
        [self addSubview:_logoImageView];
        
        float centerLineY = frame.size.height/2;
        float labelX = imageSize + 2*indent;
        float labelWidth = frame.size.width - labelX - indent;
        
        
        _mainLabel = [[UILabel alloc] init];
//        float mainLabelHeight = (frame.size.height/2)-5;
        
        NSAttributedString *mainAttributedText = [[NSAttributedString alloc] initWithString:_reward.rewardDescription attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        CGRect mainLabelRect = [mainAttributedText boundingRectWithSize:(CGSize){labelWidth, 40}
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                                  context:nil];
        
        CGSize mainLabelsize = mainLabelRect.size;
        
        //The max is 40, so pad it out if needed
        float padding = 0;
        if (mainLabelsize.height < 40) {
            padding = (40 - mainLabelsize.height)/2;
        }
        
        if (rules ) {
            [_mainLabel setFrame:CGRectMake(labelX, (2*padding)-3, labelWidth, mainLabelsize.height)];
        } else {
            [_mainLabel setFrame: CGRectMake(labelX, centerLineY-(mainLabelsize.height), labelWidth, mainLabelsize.height)];
        }
        [_mainLabel setText:reward.rewardDescription];
        [_mainLabel setFont:[UIFont systemFontOfSize:14]];
        [_mainLabel setTextColor:[UIColor blackColor]];
        [_mainLabel setTextAlignment:NSTextAlignmentLeft];
        [_mainLabel setNumberOfLines:0];
        [_mainLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [self addSubview:_mainLabel];
        
        if (rules) {
            _rulesLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, _mainLabel.frame.origin.y+_mainLabel.frame.size.height, labelWidth, 30)];
            NSAttributedString *rulesAttributedText = [[NSAttributedString alloc] initWithString:_reward.rewardRules attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            CGRect rulesLabelRect = [rulesAttributedText boundingRectWithSize:(CGSize){labelWidth, 30}
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                    context:nil];
            
            CGSize rulesLabelsize = rulesLabelRect.size;
            padding = 0;
            if (rulesLabelsize.height < 30) {
                padding = (30-rulesLabelsize.height)/2;
            }
            float rulesPadding = 0;
            if (mainLabelsize.height < 30) {
                rulesPadding = 4;
            }
            [_rulesLabel setFrame:CGRectMake(labelX, _mainLabel.frame.origin.y + _mainLabel.frame.size.height+rulesPadding, labelWidth, rulesLabelsize.height)];
            [_rulesLabel setFont:[UIFont systemFontOfSize:12]];
            [_rulesLabel setTextColor:[UIColor blackColor]];
            [_rulesLabel setText:reward.rewardRules];
            [_rulesLabel setNumberOfLines:0];
            [self addSubview:_rulesLabel];
        }
        
        if (rules) {
            _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, frame.size.height-12-padding, labelWidth, 10)];
        } else {
            _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, frame.size.height-12-padding, labelWidth, 10)];
        }
        
        NSString *action;
        
        NSArray *types = _reward.socialMediaTypes;
        if (types.count > 0) {
            if (types.count > 1) {
                //Both Networks
                switch (reward.action) {
                    case PDRewardActionCheckin:
                        action = @"Check-in or Tweet Required";
                        break;
                    case PDRewardActionPhoto:
                        action = @"Photo Required";
                        break;
                    case PDRewardActionNone:
                        action = @"No Action Required";
                    default:
                        action = @"No Action Required";
                        break;
                }
            } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
                //Facebook Only
                switch (reward.action) {
                    case PDRewardActionCheckin:
                        action = @"Check-in Required";
                        break;
                    case PDRewardActionPhoto:
                        action = @"Photo Required";
                        break;
                    case PDRewardActionNone:
                        action = @"No Action Required";
                    default:
                        action = @"No Action Required";
                        break;
                }
            } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
                //Twitter Only
                switch (reward.action) {
                    case PDRewardActionCheckin:
                        action = @"Tweet Required";
                        break;
                    case PDRewardActionPhoto:
                        action = @"Tweet with Photo Required";
                        break;
                    case PDRewardActionNone:
                        action = @"No Action Required";
                    default:
                        action = @"No Action Required";
                        break;
                }
            }
        } else if (types.count == 0) {
            switch (reward.action) {
                case PDRewardActionCheckin:
                    action = @"Check-in Required";
                    break;
                case PDRewardActionPhoto:
                    action = @"Photo Required";
                    break;
                case PDRewardActionNone:
                    action = @"No Action Required";
                default:
                    action = @"No Action Required";
                    break;
            }
        }
    
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:[NSDate date]
                                                              toDate:[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil]
                                                             options:0];
        
        NSDateComponents *untilComponents = [gregorianCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil]];
        
        NSInteger days = [components day];
        
        NSTimeInterval interval = [[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil] timeIntervalSinceDate:[NSDate date]];
        int intervalHours = interval/60/60;
        int intervalDays = interval/60/60/24;
        
        
        NSString *exp;
        if (days>6) {
            exp = [NSString stringWithFormat:@"Exp %ld %@",(long)untilComponents.day, [self monthforIndex:untilComponents.month]];
        } else if (intervalDays < 7 && intervalHours > 23) {
            exp = [NSString stringWithFormat:@"Exp %ld days",(long)intervalDays];
        } else {
            exp = [NSString stringWithFormat:@"Exp %ld hours",(long)intervalHours];
        }
        
        [_infoLabel setText:[NSString stringWithFormat:@"%@ | %@",action,exp]];
        [_infoLabel setFont:[UIFont systemFontOfSize:12]];
        [_infoLabel setTextColor:[UIColor blackColor]];
        [_infoLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_infoLabel];
        
        return self;
    }
    return nil;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (NSString*)monthforIndex:(NSInteger)index {
    switch (index) {
        case 1:
            return @"Jan";
            break;
        case 2:
            return @"Feb";
            break;
        case 3:
            return @"Mar";
            break;
        case 4:
            return @"Apr";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"Jun";
            break;
        case 7:
            return @"Jul";
            break;
        case 8:
            return @"Aug";
            break;
        case 9:
            return @"Sep";
            break;
        case 10:
            return @"Oct";
            break;
        case 11:
            return @"Nov";
            break;
        case 12:
            return @"Dec";
            break;
        default:
            break;
    }
    return nil;
}

@end
