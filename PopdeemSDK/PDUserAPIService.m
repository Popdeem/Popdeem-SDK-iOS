//
//  PDUserAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUserAPIService.h"
#import "PDConstants.h"
#import "PDUtils.h"

@interface PDUserAPIService() {
    NSMutableData *receivedData;
    NSURLConnection *theConnection;
    void (^successBlock)(PDUser *user);
    void (^failureBlock)(NSError *error);
}

@end

@implementation PDUserAPIService

- (id) init;
{
    if (self = [super init]) {
        self.baseUrl = API_URL;
        return self;
    }
    return nil;
}

- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                     success:(void (^)(PDUser *user))success
                     failure:(void (^)(NSError *error))failure {
    
    successBlock = success;
    failureBlock = failure;
    
    NSString *apiString = [NSString stringWithFormat:@"%@/%@/%@",self.baseUrl,USERS_PATH,userId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiString]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:[self apiKey] forHTTPHeaderField:@"Api-Key"];
    [mutableRequest addValue:authToken forHTTPHeaderField:@"User-Token"];
    
    receivedData = [NSMutableData data];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:mutableRequest delegate:self];
    if (!theConnection) {
        // Release the receivedData object.
        receivedData = nil;
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    theConnection = nil;
    receivedData = nil;
    failureBlock(error);
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"Succeeded! Received %ld bytes of data",[receivedData length]);
    
    NSError *jsonError;
    NSString *jsonObject = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:&jsonError];
    
    
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    theConnection = nil;
    receivedData = nil;
}

- (NSString*) apiKey {
    NSError *err;
    NSString *apiKey = [PDUtils getPopdeemApiKey:&err];
    if (err) {
        [NSException raise:@"No API Key" format:@"%@",err.localizedDescription];
    }
    return apiKey;
}

@end
