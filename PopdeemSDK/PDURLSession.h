//
//  PDURLSession.h
//  Pods
//
//  Created by Niall Quinn on 04/11/2015.
//
//

#import <Foundation/Foundation.h>

@interface PDURLSession : NSURLSession

+ (id) create;

- (void) GETRequest:(NSURLRequest *)request
             params:(NSDictionary*)params
  completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completion;


@end
