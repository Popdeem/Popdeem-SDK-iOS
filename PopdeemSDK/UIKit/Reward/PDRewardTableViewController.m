//
//  PDRewardTableViewController.m
//  Pods
//
//  Created by John Doran on 26/11/2015.
//
//

#import "PDRewardTableViewController.h"
#import "PDReward.h"
#import "PDModalLoadingView.h"
#import "RewardTableViewCell.h"
#import "NoRewardsTableViewCell.h"
#import "PDAPIClient.h"
#import "PDClaimViewController.h"
#import "PDClaimViewModel.h"

@interface PDRewardTableViewController ()
@property (nonatomic, strong)NSArray *rewards;
@property (nonatomic, strong)PDModalLoadingView *loadingView;
@end

@implementation PDRewardTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Rewards";
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];
  [self renderView];
 }

- (void)renderView {
  self.loadingView = [[PDModalLoadingView alloc] initWithDefaultsForView:self.view];
  [self.loadingView showAnimated:YES];
  
  __weak typeof(self) weakSelf = self;
  [[PDAPIClient sharedInstance]getAllRewardsSuccess:^{
    weakSelf.rewards =  [PDRewardStore allRewards];
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.tableView reloadData];

      [weakSelf.loadingView hideAnimated:YES];
    });

  } failure:^(NSError * _Nonnull error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.tableView reloadData];      
      [weakSelf.loadingView hideAnimated:YES];
    });

  }];
  
}

-(void)close{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.rewards.count != 0 ? self.rewards.count : 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PDReward *reward;
  if (self.rewards.count == 0) {
    return [[NoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"There are no Rewards available right now. Please check back later."];
  } else {
    reward = [self.rewards objectAtIndex:indexPath.row];
    return [[RewardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80) reward:reward];
  }
  
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
<<<<<<< HEAD
    if (indexPath.row > self.rewards.count-1) {
        NSLog(@"Out of bounds");
        return;
    }
    PDReward *reward = [self.rewards objectAtIndex:indexPath.row];
    PDClaimViewController *claimController = [[PDClaimViewController alloc] initWithMediaTypes:@[@(FacebookOnly)] andReward:reward];
    [[self navigationController] pushViewController:claimController animated:YES];
=======
  NSLog(@"TODO - NIALL");
  
  UIViewController *vc = [UIViewController new];
  UILabel *l = [UILabel new];
  vc.title = @"Claim Screen";
  [self.navigationController pushViewController:[UIViewController new] animated:YES];
>>>>>>> 1bf1aa8e9081620d99b5bfd46615e45f28907f10
}

@end
