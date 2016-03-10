//
//  ClaimViewController.m
//  Popdeem
//
//  Created by Niall Quinn on 14/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "ClaimViewController.h"
#import "RewardTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PDUser+Facebook.h"
#import "NQLoadingView.h"
#import "BrandRewardListVC.h"
#import "PDSocialMediaFriend.h"
#import "PDSocialMediaManager.h"
#import "AppConfig.h"
#import "FlurryLogger.h"

#define TEXTFIELD_MAX_LENGTH 140
#define isiPhone5OrNewer  ([[UIScreen mainScreen] bounds].size.height >= 568)?TRUE:FALSE

@interface ClaimViewController() {
    
    __weak IBOutlet SZTextView *claimTextView;
    __weak IBOutlet UILabel *rewardDescriptionLabel;
    __weak IBOutlet UILabel *rewardRulesLabel;
    __weak IBOutlet UILabel *rewardInfoLabel;
    __weak IBOutlet UIImageView *rewardImageView;
    __weak IBOutlet UIView *buttonsView;
    __weak IBOutlet UIButton *addPhotoButton;
    __weak IBOutlet UIButton *addFriendsButton;
    __weak IBOutlet UIButton *facebookButton;
    __weak IBOutlet UIButton *twitterButton;
    __weak IBOutlet UIView *forcedTagView;
    __weak IBOutlet UIView *claimButtonView;
    __weak IBOutlet UIView *facebookButtonView;
    __weak IBOutlet UIView *twitterButtonView;
    __weak IBOutlet UIView *addFriendsButtonView;
    __weak IBOutlet UIButton *claimButton;
    
    __weak IBOutlet UILabel *twitterCharacterCountLabel;
    __weak IBOutlet UILabel *forcedTagLabel;
    
    __weak IBOutlet UIView *rewardView;
    
    __weak IBOutlet NSLayoutConstraint *claimBoxHeightConstraint;
    
    __weak IBOutlet NSLayoutConstraint *forcedTagViewHeightConstraint;
    __weak IBOutlet UIView *keyboardHider;
    __weak IBOutlet UILabel *withLabel;
    
    __weak IBOutlet NSLayoutConstraint *rewardDescriptionLabelHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *rewardViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *rewardRulesLabelHeightConstraint;
 
    
    CGRect keyboardRect;
    CALayer *textViewBordersLayer;
    CALayer *buttonsViewBordersLayer;
    CALayer *twitterViewBordersLayer;
    CALayer *claimViewBordersLayer;
    CALayer *facebookButtonViewBordersLayer;
    CALayer *twitterButtonViewBordersLayer;
    float topTextView;
    BOOL didAddPhoto;
    UIImage *image;
    UIView *bgDisablerView;
    NQLoadingView *loadingView;
    BOOL goingToTag;
    UIImageView *imageView;
    float fullHeight;
    
    BOOL willTweet;
    BOOL willFacebook;
    BOOL mustTweet;
    BOOL mustFacebook;
    
    float preferredRewardViewheight;
    
}

@end

@implementation ClaimViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDClaimViewController" bundle:podBundle]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = translationForKey(@"popdeem.claims.title", @"Claim");
    return self;
  }
  return nil;
}

- (void) viewDidLoad {
    
    [facebookButton setImage:[UIImage imageNamed:@"facebookSelected"] forState:UIControlStateSelected];
    [facebookButton setImage:[UIImage imageNamed:@"facebookDeselected"] forState:UIControlStateNormal];
    [facebookButton setTitleColor:[UIColor colorWithRed:0.169 green:0.247 blue:0.537 alpha:1.000] forState:UIControlStateSelected];
    [facebookButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [twitterButton setImage:[UIImage imageNamed:@"twitterDeselected"] forState:UIControlStateNormal];
    [twitterButton setImage:[UIImage imageNamed:@"twitterSelected"] forState:UIControlStateSelected];
    [twitterButton setTitleColor:[UIColor colorWithRed:0.200 green:0.412 blue:0.596 alpha:1.000] forState:UIControlStateSelected];
    [twitterButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //Should be only one here
    NSArray *types = _reward.socialMediaTypes;
    if (types.count > 0) {
        if (types.count > 1) {
            //Both Networks
            mustFacebook = NO;
            mustTweet = NO;
            willFacebook = YES;
            willTweet = NO;
            [facebookButton setSelected:YES];
            [twitterButton setSelected:NO];
        } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
            //Facebook Only
            mustFacebook = YES;
            mustTweet = NO;
            willFacebook = YES;
            willTweet = NO;
            [facebookButton setSelected:YES];
            [twitterButton setSelected:NO];
        } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
            //Twitter Only
            mustFacebook = NO;
            mustTweet = YES;
            willFacebook = NO;
            willTweet = YES;
            forcedTagViewHeightConstraint.constant = 30;
            [facebookButton setSelected:NO];
            [twitterButton setSelected:YES];
        }
    } else {
        mustFacebook = NO;
        mustTweet = NO;
        willFacebook = YES;
        willTweet = NO;
        [facebookButton setImage:[UIImage imageNamed:@"facebookSelected"] forState:UIControlStateNormal];
        [twitterButton setImage:[UIImage imageNamed:@"twitterDeselected"] forState:UIControlStateNormal];
    }
    
    if (mustTweet) {
        forcedTagViewHeightConstraint.constant = 30;
        [forcedTagLabel setHidden:NO];
        [twitterCharacterCountLabel setHidden:NO];
        [self calculateTwitterCharsLeft];
    } else {
        forcedTagViewHeightConstraint.constant = 0;
    }
        
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    [self setTitle:@"Claim Reward"];
    if (!_reward) {
        NSLog(@"Something is wrong");
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    buttonsView.clipsToBounds = YES;
    buttonsViewBordersLayer = [CALayer layer];
    buttonsViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
    buttonsViewBordersLayer.borderWidth = 0.5;
    buttonsViewBordersLayer.frame = CGRectMake(-1, 0, buttonsView.frame.size.width+2, buttonsView.frame.size.height);
    [buttonsView.layer addSublayer:buttonsViewBordersLayer];
    buttonsView.clipsToBounds = YES;
    
    [claimTextView setScrollEnabled:NO];
    claimTextView.delegate = self;
    textViewBordersLayer = [CALayer layer];
    textViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
    textViewBordersLayer.borderWidth = 0.5;
    textViewBordersLayer.frame = CGRectMake(-1, 0, claimTextView.frame.size.width+2, claimTextView.frame.size.height+1);
    [claimTextView.layer addSublayer:textViewBordersLayer];
    claimTextView.clipsToBounds = YES;
    if (_reward.twitterPrefilledMessage) {
        [claimTextView setText:_reward.twitterPrefilledMessage];
    }
    
    [claimTextView setPlaceholder:@"What are you up to?"];
    [claimTextView setTintColor:[UIColor darkGrayColor]];
    claimTextView.textContainerInset = UIEdgeInsetsMake(10, 8, 5, 10);
    [claimTextView setFont:[AppConfig claimTextViewFont]];
    [claimTextView setTextColor:[AppConfig claimTextViewFontColor]];

    [addPhotoButton setEnabled:YES];
    [addPhotoButton addTarget:self action:@selector(showPhotoActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [addFriendsButton addTarget:self action:@selector(addFriendsButtonPressed) forControlEvents:UIControlEventTouchUpInside];


    [forcedTagLabel setText:_reward.twitterForcedTag];
    [forcedTagLabel setTextColor:[UIColor colorWithRed:0.204 green:0.506 blue:0.996 alpha:1.000]];
//    twitterViewBordersLayer = [CALayer layer];
//    twitterViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
//    twitterViewBordersLayer.borderWidth = 0.5;
//    twitterViewBordersLayer.frame = CGRectMake(-1, -1, forcedTagView.frame.size.width+2, 0.5);
//    [forcedTagView.layer addSublayer:twitterViewBordersLayer];
    
//    claimViewBordersLayer = [CALayer layer];
//    claimViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
//    claimViewBordersLayer.borderWidth = 0.5;
//    claimViewBordersLayer.frame = CGRectMake(-1, 0, claimButtonView.frame.size.width+2, claimButtonView.frame.size.height);
//    [claimButtonView.layer addSublayer:claimViewBordersLayer];
//    [claimButton setBackgroundColor:[AppConfig topBarColor]];
//    claimButtonView.clipsToBounds = YES;
    
    [facebookButtonView setFrame:CGRectMake(facebookButtonView.frame.origin.x, facebookButtonView.frame.origin.y, self.view.frame.size.width/2, 40) ];
    
    facebookButtonViewBordersLayer = [CALayer layer];
    facebookButtonViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
    facebookButtonViewBordersLayer.borderWidth = 0.5;
    facebookButtonViewBordersLayer.frame = CGRectMake(-1, 0, facebookButtonView.frame.size.width+1, facebookButtonView.frame.size.height);
    [facebookButtonView.layer addSublayer:facebookButtonViewBordersLayer];
    facebookButtonView.clipsToBounds = YES;
    
    twitterButtonViewBordersLayer = [CALayer layer];
    twitterButtonViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
    twitterButtonViewBordersLayer.borderWidth = 0.5;
    twitterButtonViewBordersLayer.frame = CGRectMake(-1, 0, facebookButtonView.frame.size.width+2, facebookButtonView.frame.size.height);
    [twitterButtonView.layer addSublayer:twitterButtonViewBordersLayer];
    twitterButtonView.clipsToBounds = YES;
    
    [keyboardHider setHidden:YES];
    UITapGestureRecognizer *hiderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiderTap)];
    [keyboardHider addGestureRecognizer:hiderTap];
    
    if (!IS_IPHONE_4_OR_LESS) {
        RewardTableViewCell *tvc = [[RewardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80) reward:_reward];
        [rewardView addSubview:tvc];
        rewardViewHeightConstraint.constant = 80;
    } else {
        rewardViewHeightConstraint.constant = 0;
    }

    
}


- (void) hiderTap {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
    
        [keyboardHider setHidden:YES];
        if (!IS_IPHONE_4_OR_LESS) {
            rewardViewHeightConstraint.constant = (IS_IPHONE_4_OR_LESS) ? 0 : 80;
        }
        [claimTextView resignFirstResponder];
        [rewardView setHidden:NO];
                         self.navigationItem.rightBarButtonItem = nil;
                         self.navigationItem.hidesBackButton = NO;
                         [self setTitle:@"Claim Reward"];
                     } completion:^(BOOL finished){}];
}

- (void) calculateTwitterCharsLeft {
    //Build the string
    NSString *endString = [NSString stringWithString:claimTextView.text];
    if (_reward.twitterForcedTag) {
        endString = [endString stringByAppendingString:[NSString stringWithFormat:@" %@",_reward.twitterForcedTag]];
    }
    NSString *sampleMediaString = @"";
    for (int i = 0 ; i < _reward.twitterMediaLength ; i++) {
        sampleMediaString = [sampleMediaString stringByAppendingString:@" "];
    }
    
    //All rewards have a download link now, so deduct this media string length
    endString = [endString stringByAppendingString:[NSString stringWithFormat:@" %@",sampleMediaString]];
    
    if (image) {
        endString = [endString stringByAppendingString:[NSString stringWithFormat:@" %@",sampleMediaString]];
    }
    
    int charsLeft = 140 - (int)endString.length;
    
    if (charsLeft < 1) {
        [twitterCharacterCountLabel setTextColor:[UIColor redColor]];
    } else {
        [twitterCharacterCountLabel setTextColor:[UIColor colorWithRed:0.204 green:0.506 blue:0.996 alpha:1.000]];
    }
    
    [twitterCharacterCountLabel setText:[NSString stringWithFormat:@"%d",charsLeft]];
}

- (void) viewWillAppear:(BOOL)animated {
    goingToTag = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [claimButton setBackgroundColor:[AppConfig topBarColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!goingToTag) {
        for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
            if (f.selected) {
                f.selected = NO;
            }
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidAppear:(BOOL)animated {
    
    fullHeight = self.view.frame.size.height;
    
    if (_textView) {
        [claimTextView becomeFirstResponder];
    }
    
    NSMutableArray *friendsTagged = [NSMutableArray array];
    for (PDSocialMediaFriend *friend in [PDUser taggableFriends]) {
        if (friend.selected) {
            [friendsTagged addObject:friend];
            [withLabel setHidden:NO];
        }
    }

    NSMutableString *withString = [[NSMutableString alloc] init];
    if (friendsTagged.count > 2) {
        withString = [NSMutableString stringWithFormat:@"%@ and %lu others.",[[friendsTagged objectAtIndex:0] name], [friendsTagged count]-1];
    } else if (friendsTagged.count == 2) {
        withString = [NSMutableString stringWithFormat:@"%@ and %@",[[friendsTagged objectAtIndex:0] name], [[friendsTagged objectAtIndex:1] name]];
    } else if (friendsTagged.count == 1) {
        withString = [NSMutableString stringWithFormat:@"%@",[[friendsTagged objectAtIndex:0] name]];
    } else {
        [withLabel setHidden:YES];
    }
    
    NSMutableAttributedString *attWith = [[NSMutableAttributedString alloc] initWithString:@"With " attributes:@{NSForegroundColorAttributeName:[AppConfig claimWithLabelLightFontColor],NSFontAttributeName:[AppConfig claimWithLabelFont]}];
    
    NSMutableAttributedString *attNames = [[NSMutableAttributedString alloc] initWithString:withString attributes:@{NSForegroundColorAttributeName:[AppConfig claimWithLabelHighlightedFontColor],NSFontAttributeName:[AppConfig claimWithLabelFont]}];
    
    NSMutableAttributedString *whole = [[NSMutableAttributedString alloc] initWithAttributedString:attWith];
    [whole appendAttributedString:attNames];
    
    [withLabel setAttributedText:whole];
    [self.view bringSubviewToFront:withLabel];
    [FlurryLogger logEvent:@"Claim Page Opened" params:nil];
    
    
}

- (void) updateViewForKeyboard {
    
}

- (void)keyboardWillChange:(NSNotification *)notification {
    keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
    NSLog(@"%.2f",keyboardRect.size.height);
    [self updateViewForKeyboard];
}

- (void) keyboardWillShow:(NSNotification*)notification {
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         UIBarButtonItem *typingDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(hiderTap)];
                         self.navigationItem.rightBarButtonItem = typingDone;
                         self.navigationItem.hidesBackButton = YES;
                         [keyboardHider setHidden:NO];
                         [self.view bringSubviewToFront:keyboardHider];
                         [claimTextView becomeFirstResponder];
                         rewardViewHeightConstraint.constant = 0;
                         [rewardView setHidden:YES];
                         [self setTitle:@"Add Message"];
                    } completion:^(BOOL finished){}];
    
    [self.view setNeedsLayout];
}

- (void) keyboardWillHide:(NSNotification*)notification {
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Do any prep for tag friends view
    goingToTag = YES;
}

#pragma mark - Tag Friends -

- (void) addFriendsButtonPressed {
    [self performSegueWithIdentifier:@"presentFriendPicker" sender:self];
    
}

#pragma mark - text View Del - 

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Prevent crashing undo bug – see note below.

    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return newLength <= TEXTFIELD_MAX_LENGTH;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self calculateTwitterCharsLeft];
}
#pragma mark - Adding Images

- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (UIImage *)resizeImage:(UIImage *)_image
        withMinDimension:(CGFloat)minDimension
{
    
    CGFloat aspect = _image.size.width / _image.size.height;
    CGSize newSize;
    
    if (_image.size.width > _image.size.height) {
        newSize = CGSizeMake(minDimension*aspect, minDimension);
    } else {
        newSize = CGSizeMake(minDimension, minDimension/aspect);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [_image drawInRect:newImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        
    }
    
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(claimTextView.frame.size.width-70, 10, 60, 60)];
        [claimTextView addSubview:imageView];
        [imageView setClipsToBounds:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setHidden:YES];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoActionSheet)];
        [imageView addGestureRecognizer:imageTap];
        [imageView setUserInteractionEnabled:YES];
    }
    
    [self updateViewForKeyboard];
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    image = [self resizeImage:img withMinDimension:480];
    //    CGRect rect = CGRectMake(0,0,500,500);
    //    UIGraphicsBeginImageContext( rect.size );
    //    [chosenImage drawInRect:rect];
    //    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    NSData *imageData = UIImagePNGRepresentation(picture1);
    //    UIImage *img=[UIImage imageWithData:imageData];
    
    imageView.image = img;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    self.pictureView.layer.cornerRadius = 10;
    imageView.backgroundColor = [UIColor blackColor];
    imageView.layer.masksToBounds = YES;
    imageView.layer.shadowColor = [UIColor colorWithRed:0.831 green:0.831 blue:0.831 alpha:1.000].CGColor;
    imageView.layer.shadowOpacity = 0.9;
    imageView.layer.shadowRadius = 1.0;
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    imageView.layer.borderWidth = 2.0f;
    [imageView setHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    didAddPhoto = YES;
    
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [claimTextView setTextContainerInset:UIEdgeInsetsMake(10, 8, 10, 70)];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    [claimTextView becomeFirstResponder];
    [self performSelector:@selector(updateViewForKeyboard) withObject:nil afterDelay:0.5];
    
    [self calculateTwitterCharsLeft];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [claimTextView becomeFirstResponder];
    [self performSelector:@selector(updateViewForKeyboard) withObject:nil afterDelay:0.5];
    [imageView setHidden:YES];
    imageView.image = nil;
}

- (void) checkPermissions {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        [self postToFacebook:nil];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
                [[[PDUser sharedInstance] facebookParams] setAccessToken:[[FBSDKAccessToken currentAccessToken] tokenString]];
                [self postToFacebook:nil];
            } else {
                UIAlertView *noperm = [[UIAlertView alloc] initWithTitle:@"Invalid Permissions" message:@"You must grant publish permissions in order to make this action" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [noperm show];
            }
        }];

    }
}

- (IBAction) postToFacebook:(id)sender {
    
    if (!willTweet && !willFacebook) {
        UIAlertView *noPost = [[UIAlertView alloc] initWithTitle:@"No Network Selected" message:@"You must select at least one social network in order to complete this action." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noPost show];
        return;
    }
    
    if (willTweet) {
        [[PDSocialMediaManager manager] verifyTwitterCredentialsCompletion:^(BOOL connected, NSError *error){
            if (!connected) {
                [self connectTwitter:^(){
                    [self makeClaim];
                } failure:^(NSError *error) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Twitter not connected" message:@"You must connect your twitter account in order to post to Twitter" delegate:self cancelButtonTitle:@"Back" otherButtonTitles: nil];
                    [av show];
                }];
                return;
            }
            if (twitterCharacterCountLabel.text.integerValue < 0) {
                UIAlertView *tooMany = [[UIAlertView alloc] initWithTitle:@"Tweet Too Long" message:@"You have written a post longer than the allowed 140 characters. Please shorten your post." delegate:self cancelButtonTitle:@"Back" otherButtonTitles: nil];
                [tooMany show];
                return;
            }
            [self makeClaim];
        }];
        return;
    }
    if ([claimTextView isFirstResponder]) {
        [claimTextView resignFirstResponder];
    }
    [self makeClaim];
}

- (void) makeClaim {
    
    if (_reward.action == PDRewardActionPhoto && image == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Required"
                                                        message:@"A photo is required for this action. Please add a photo"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert setTag:1];
        [alert show];
        return;
    }
    
    PDAPIClient *client = [PDAPIClient sharedInstance];
    NSString *message = [claimTextView text];
    
    if (_reward.twitterForcedTag) {
        message = [message stringByAppendingFormat:@" %@",_reward.twitterForcedTag];
    }
    
    //    if (_reward.downloadLink) {
    //        message = [message stringByAppendingFormat:@" %@",_reward.downloadLink];
    //    }
    
    NSMutableArray *taggedFriends = [NSMutableArray array];
    for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
        if (f.selected) {
            [taggedFriends addObject:f.tagIdentifier];
        }
    }
    
    __block NSInteger rewardId = _reward.identifier;
    
    [client claimReward:_reward.identifier location:_location withMessage:message taggedFriends:taggedFriends image:image facebook:willFacebook twitter:willTweet success:^(){
        [self didClaimRewardId:rewardId];
    } failure:^(NSError *error){
        [self PDAPIClient:client didFailWithError:error];
    }];
    
    bgDisablerView = [[UIView alloc] initWithFrame:self.view.frame];
    [bgDisablerView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.view addSubview:bgDisablerView];
    
    loadingView = [[NQLoadingView alloc] initSmallDarkForView:self.view titleText:@"Claiming Reward" descriptionText:@"This could take up to 30 seconds"];
    [loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [loadingView showAnimated:YES];
    
    NSString *alertMessage = @"";
    
    switch (_reward.type) {
        case PDRewardTypeCoupon:
        case PDRewardTypeInstant:
            alertMessage = @"Your coupon will appear in your wallet shortly";
            break;
        case PDRewardTypeSweepstake:
            alertMessage = @"Your sweepstake ticket will appear in your wallet shortly";
        default:
            break;
    }
}

#pragma mark - PDAPIClientDelegate -
- (void) didClaimRewardId:(NSInteger)rewardId {
    
    [loadingView hideAnimated:YES];
    [bgDisablerView setHidden:YES];
    
    PDCustomIOS7AlertView *alertView = [[PDCustomIOS7AlertView alloc] init];
  
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 160)];
    
    UIImageView *_rimageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentView.center.x-40,5, 80, 80)];
    _rimageView.contentMode = UIViewContentModeScaleAspectFill;
    _rimageView.layer.cornerRadius = 5.0;
    _rimageView.layer.masksToBounds = YES;
    _rimageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _rimageView.layer.borderWidth = 1.0f;
//    [_rimageView setImage:_reward.brand.logoImage];
    
    [contentView addSubview:_rimageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, contentView.frame.size.width, 25)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont boldSystemFontOfSize:16]];
    [title setText:@"Reward Claimed!"];
    
    [title setTextColor:[UIColor blackColor]];
    [contentView addSubview:title];
    
    UILabel *_message = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, contentView.frame.size.width-20, 35)];
    _message.lineBreakMode = NSLineBreakByWordWrapping;
    _message.numberOfLines = 2;
    [_message setTextAlignment:NSTextAlignmentCenter];
    [_message setFont:[UIFont systemFontOfSize:14]];
    [_message setText:@"Go to Wallet now to Redeem!"];
    
    [_message setTextColor:[UIColor darkGrayColor]];
    [contentView addSubview:_message];
    
    [alertView setContainerView:contentView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Go to Wallet", nil]];
    [alertView setUseMotionEffects:TRUE];
    [alertView setDelegate:self];
    [alertView setTag:0];
    [alertView show];
    
    NSMutableDictionary *flurryParams = [NSMutableDictionary dictionary];
    [flurryParams setObject:[NSString stringWithFormat:@"Reward: %li",_reward.identifier] forKey:@"Reward Id"];
    [FlurryLogger logEvent:@"Claim Reward" params:flurryParams];
    
    [PDRewardStore deleteReward:_reward.identifier];
}

- (void) PDAPIClient:(PDAPIClient *)client didFailWithError:(NSError *)error {
    NSLog(@"Error: %@",error);
    [loadingView hideAnimated:YES];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Something went wrong. Please try again later" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
    [av show];
}

#pragma mark - Photo Action Sheet -

- (void) showPhotoActionSheet {
//    if ([claimTextView isFirstResponder]) {
//        [claimTextView resignFirstResponder];
//    }
    
    _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _alertWindow.rootViewController = [UIViewController new];
    _alertWindow.windowLevel = 10000001;
    _alertWindow.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Test" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.alertWindow.hidden = YES;
        weakSelf.alertWindow = nil;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.alertWindow.hidden = YES;
        weakSelf.alertWindow = nil;
        [weakSelf takePhoto];
        if ([claimTextView isFirstResponder]) {
            [claimTextView resignFirstResponder];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.alertWindow.hidden = YES;
        weakSelf.alertWindow = nil;
        [weakSelf selectPhoto];
        if ([claimTextView isFirstResponder]) {
            [claimTextView resignFirstResponder];
        }
    }]];
    
    [_alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void) customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"Go to Wallet");
            for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
                if (f.selected) {
                    [f setSelected:NO];
                }
            }
            [self dismissToWallet];
            break;
        case 1:
            NSLog(@"Back to Root");
            for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
                if (f.selected) {
                    [f setSelected:NO];
                }
            }
            [self dismissViewControllerAnimated:YES
                                     completion:NULL];
        default:
            break;
    }
    
    [alertView removeFromSuperview];
}

- (void) dismissToWallet {

    NSArray * stack = self.navigationController.viewControllers;
    BrandRewardListVC *_parent;
    for (int i=(int)stack.count-1; i > 0; --i) {
        if (stack[i] == self) {
            _parent = (BrandRewardListVC*)stack[i-1];
        }
    }
    
    for (PDReward *r in _parent.tableData) {
        if (r.identifier == _reward.identifier) {
            [_parent.tableData removeObject:r];
            break;
        }
    }
    [_parent.tableView reloadData];
    [_parent.tableView reloadInputViews];
    [_parent setShouldGoToWallet:YES];
    [self.navigationController popViewControllerAnimated:YES];

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

- (IBAction)toggleTwitter:(id)sender {
    
    if (mustTweet) {
        willTweet = YES;
        UIAlertView *twitterV = [[UIAlertView alloc] initWithTitle:@"Cannot Deselect" message:@"This reward must be claimed with a tweet. You can also post to Facebook if you wish" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [twitterV show];
        return;
    }
    
    if (willTweet) {
        willTweet = NO;
        [forcedTagLabel setHidden:YES];
        [twitterCharacterCountLabel setHidden:YES];
        [twitterButton setSelected:NO];
        return;
    }

    willTweet = YES;
    [twitterButton setSelected:YES];
    [forcedTagLabel setHidden:NO];
    [twitterCharacterCountLabel setHidden:NO];
    [self calculateTwitterCharsLeft];
}

- (IBAction)toggleFacebook:(id)sender {
    
    if (mustFacebook) {
        willFacebook = YES;
        UIAlertView *fbV = [[UIAlertView alloc] initWithTitle:@"Cannot Deselect" message:@"This reward must be claimed with a Facebook post. You can also post to Twitter if you wish" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [fbV show];
        return;
    }
    
    if (willFacebook) {
        willFacebook = NO;
        [facebookButton setSelected:NO];
        return;
    }
    
    if ([[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
        willFacebook = YES;
        [facebookButton setSelected:YES];
    } else {
        [[PDSocialMediaManager manager] loginWithFacebookReadPermissions:@[@"public_profile", @"email", @"user_birthday", @"user_posts", @"user_friends", @"user_education_history"] registerWithPopdeem:YES success:^(void) {
            willFacebook = YES;
            [facebookButton setSelected:YES];
        } failure:^(NSError *error) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"We couldnt connect you to Facebook" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [av show];
            willFacebook = NO;
            [facebookButton setSelected:NO];
        }];
    }
}

- (void) connectTwitter:(void (^)(void))success failure:(void (^)(NSError *failure))failure {
    PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:self];
    
    loadingView = [[NQLoadingView alloc] initSmallDarkForView:self.view titleText:@"Please Wait" descriptionText:@"Connecting Twitter"];
    [loadingView showAnimated:YES];
    
    [manager loginWithTwitter:^(void){
            //Twitter is logged in
        [twitterButton setImage:[UIImage imageNamed:@"Twitter"] forState:UIControlStateNormal];
        willTweet = YES;
        [twitterButton setImage:[UIImage imageNamed:@"twitterSelected"] forState:UIControlStateNormal];
        [loadingView hideAnimated:YES];
        forcedTagViewHeightConstraint.constant = 30;
        [self calculateTwitterCharsLeft];
        [facebookButton setEnabled:NO];
        [addFriendsButton setEnabled:NO];
        [withLabel setHidden:YES];
        success();
    } failure:^(NSError *error) {
        //Some error
        NSLog(@"Twitter didnt log in: %@",error);
        if (!mustTweet) {
            willTweet = NO;
            [twitterButton setImage:[UIImage imageNamed:@"twitterDeselected"] forState:UIControlStateNormal];
            forcedTagViewHeightConstraint.constant = 0;
        }
        [loadingView hideAnimated:YES];
        failure(error);
    }];
    
}

@end