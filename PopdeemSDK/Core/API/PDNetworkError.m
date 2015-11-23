//
//  PDNetworkError.m
//  Pods
//
//  Created by Niall Quinn on 17/11/2015.
//
//

#import "PDNetworkError.h"

@implementation PDNetworkError

+ (NSError*) errorForStatusCode:(NSInteger)statusCode {
    NSString *errorDescription;
    switch (statusCode) {
        case 500:
            errorDescription = @"Internal Server Error";
            break;
        case 501:
            errorDescription = @"Not Implemented";
            break;
        case 502:
            errorDescription = @"Bad Gateway";
            break;
        case 503:
            errorDescription = @"Service Unavailable";
            break;
        case 504:
            errorDescription = @"Gateway Timeout";
            break;
        case 429:
            errorDescription = @"Too Many Requests";
        default:
            errorDescription = @"Something Went Wrong";
            break;
    }
    NSError *error = [[NSError alloc] initWithDomain:@"PDNetworkError" code:statusCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorDescription,NSLocalizedDescriptionKey, nil]];
    return error;
}

@end
