//
//  PDBGScanResponseModel.m
//  PopdeemSDK
//
//  Created by niall quinn on 03/04/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDBGScanResponseModel.h"
#import "PDLogger.h"

@implementation PDBGScanResponseModel

- (id) initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
  if ([super initWithDictionary:dict error:&err]) {
    return self;
  }
  PDLogError(@"JSONModel Error on Social Response Params: %@",err);
  return nil;
}

+ (JSONKeyMapper*)keyMapper {
  return  [JSONKeyMapper mapperForSnakeCase];
}

@end
