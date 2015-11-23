//
//  PDSocialMediaFriend.m
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

#import "PDSocialMediaFriend.h"

@interface PDSocialMediaFriend () {

}

@end

@implementation PDSocialMediaFriend

- (id) initWithName:(NSString*)name tagIdentifier:(NSString*)tagIdentifier profilePictureUrl:(NSString*)profilePictureUrl {
    if (self = [super init]) {
        self.name = name;
        self.tagIdentifier = tagIdentifier;
        self.profilePictureURL = profilePictureUrl;
        return self;
    }
    return nil;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"Social Media Friend: Name: %@, ID: %@, PicURL: %@",_name,_tagIdentifier,_profilePictureURL];
}

- (UIImage*)getImageWithHeight:(int)height width:(int)width {
    
    NSString *additional = [NSString stringWithFormat:@"?redirect=0&height=%d&type=normal&width=%d",height,width];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[self.profilePictureURL stringByAppendingString:additional]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:&error];
    NSURL *newUrl = [NSURL URLWithString:[[resDict objectForKey:@"data"] objectForKey:@"url"]];
    NSData *imageData = [NSData dataWithContentsOfURL:newUrl];
    UIImage *image = [UIImage imageWithData:imageData];
    [self setImage:image];
    
    return image;
    
}

- (NSComparisonResult)compare:(PDSocialMediaFriend *)otherObject {
    return [self.name compare:otherObject.name];
}

- (void) setSelected:(BOOL)selected {
    _selected = selected;
    NSLog(@"Friend: %@, Selected: %@",self.name,self.selected ? @"YES" : @"NO");
}

@end
