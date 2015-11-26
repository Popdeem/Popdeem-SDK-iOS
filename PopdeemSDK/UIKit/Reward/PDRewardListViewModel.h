//
//  PDRewardListViewModel.h
//  Pods
//
//  Created by John Doran Home on 26/11/2015.
//
//

#import <Foundation/Foundation.h>

@interface PDRewardListViewModel : NSObject
@property (nonatomic, strong)NSArray *rewards;

- (void)fetchData;

@end
