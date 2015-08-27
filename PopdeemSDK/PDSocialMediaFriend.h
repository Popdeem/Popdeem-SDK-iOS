//
//  PDSocialMediaFriend.h
//  Popdeem_SDK_iOS
//
//  Created by Niall Quinn (niall@popdeem.com) on 16/10/2014.
//  Copyright (c) 2015 Popdeem
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

@import Foundation;
@import UIKit;

@interface PDSocialMediaFriend : NSObject

//User name
@property (nonatomic, retain) NSString *name;

/*
 The Social media ID to be used for tagging
 In the case of Facebook, use one-time tagging token
 In the case of Twitter, use @screenName
 */
@property (nonatomic, retain) NSString *tagIdentifier;

//Url to retrieve profile picture for friend
@property (nonatomic, retain) NSString *profilePictureURL;

@property (nonatomic, retain) UIImage *image;

//Selected property for tagging/untagging
@property (nonatomic) BOOL selected;

- (id) initWithName:(NSString*)name tagIdentifier:(NSString*)tagIdentifier profilePictureUrl:(NSString*)profilePictureUrl;
- (UIImage*)getImageWithHeight:(int)height width:(int)width;
- (void) setSelected:(BOOL)selected;

@end
