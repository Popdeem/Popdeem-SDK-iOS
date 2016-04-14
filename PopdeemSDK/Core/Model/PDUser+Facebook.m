//
//  PDUser+Facebook.m
//  Popdeem_SDK_iOS
//
//  Created by Niall Quinn (niall@popdeem.com) on 17/10/2014.
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

#import "PDUser+Facebook.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PDUser.h"
#import "PDSocialMediaFriend.h"

@implementation PDUser (Facebook)


+ (id) taggableFriends {
  static NSMutableArray *globalArray;
  static dispatch_once_t sharedToken;
  dispatch_once(&sharedToken, ^{
    globalArray = [[NSMutableArray alloc] init];
  });
  return globalArray;
}

- (void) refreshFacebookFriendsCallback:(void(^)(BOOL response))callback {
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/taggable_friends?limit=5000"
                                      parameters:@{@"fields": @"id, name"}
                                      HTTPMethod:@"GET"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             [[PDUser taggableFriends] removeAllObjects];
             NSArray* friends = [result objectForKey:@"data"];
             for (NSDictionary *item in friends) {
                 
                 NSString *facebookID = [item objectForKey:@"id"];
                 NSString *name = [item objectForKey:@"name"];
                 NSString *picUrl = [[[item objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                 PDSocialMediaFriend *f = [[PDSocialMediaFriend alloc] initWithName:name tagIdentifier:facebookID profilePictureUrl:picUrl];
                 
                 [[PDUser taggableFriends] addObject:f];
             }
             
             NSArray *sortedArray = [[PDUser taggableFriends] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                 NSString *first = [(PDSocialMediaFriend*)a name];
                 NSString *second = [(PDSocialMediaFriend*)b name];
                 return [first compare:second];
             }];
             
           [[PDUser taggableFriends] removeAllObjects];
           [[PDUser taggableFriends] addObjectsFromArray:sortedArray];
           
             NSLog(@"Got Friends, there are %ld",[[PDUser taggableFriends] count]);
             callback(YES);
         } else {
             NSLog(@"%@",error);
             callback(NO);
         }
         
    }];
}

- (void) gatherUserLikesCallback:(void(^)(BOOL response))callback {
    [self gatherUserLikesWithPath:@"/me/likes?limit=100"];
    self._callback = callback;
}

- (void) gatherUserLikesWithPath:(NSString*)path {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:path parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *likes = [result objectForKey:@"data"];
            self.likesCount += (int)likes.count;
            
            if ([result objectForKey:@"paging"]) {
                [self userLikesPaginated:[[result objectForKey:@"paging"] objectForKey:@"next"]];
            } else {
                self._callback(YES);
            }
        } else {
            NSLog(@"error");
        }

    }];
}

- (void) countAndCheckForNext:(NSMutableDictionary *)dict {
    if ([dict objectForKey:@"likes"]) {
        self.likesCount += (int)[[dict objectForKey:@"likes"] count];
    }
    if ([[dict objectForKey:@"paging"] objectForKey:@"next"]) {
        [self userLikesPaginated:[[dict objectForKey:@"paging"] objectForKey:@"next"]];
    } else {
        self._callback(YES);
    }
}

- (void)userLikesPaginated:(NSString *)paginationUrl{
//TODO - Update to Latest FBSDK
    /* make the API call */
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithSession:FBSDKS.activeSession graphPath:nil];
//    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
//    [connection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        
//        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"likes": [result objectForKey:@"data"], @"paging": [result objectForKey:@"paging"]}];
//        [self countAndCheckForNext:dictionary];
//    }];
//    
//    // Override the URL using the one passed back in 'next|previous'.
//    NSURL *url = [NSURL URLWithString:paginationUrl];
//    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
//    connection.urlRequest = urlRequest;
//    
//    [connection start];
}

- (NSMutableArray*) selectedFriendsJSONRepresentation {
  NSMutableArray *selected = [NSMutableArray array];
  for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
    if (f.selected) {
      [selected addObject:[NSDictionary dictionaryWithObjectsAndKeys:f.name,@"name",f.tagIdentifier,@"id", nil]];
    }
  }
  return selected;
}

@end
