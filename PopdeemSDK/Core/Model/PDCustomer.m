//
//  PDCustomer.m
//  Bolts
//
//  Created by Niall Quinn on 14/02/2018.
//

#import "PDCustomer.h"

@implementation PDCustomer

- (id) initWithJSON:(NSString*)json {
  
  NSError *err;
  if (self = [super initWithString:json error:&err]) {
    return  self;
  }
  PDLogError(@"JSONModel Error on Customer: %@",err);
  return  nil;
}

+ (JSONKeyMapper*)keyMapper {
  return [JSONKeyMapper mapperForSnakeCase];
}

@end
