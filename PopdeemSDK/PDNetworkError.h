//
//  PDNetworkError.h
//  Pods
//
//  Created by Niall Quinn on 17/11/2015.
//
//

#import <Foundation/Foundation.h>

@interface PDNetworkError : NSObject

+ (NSError*) errorForStatusCode:(NSInteger)statusCode;

@end
