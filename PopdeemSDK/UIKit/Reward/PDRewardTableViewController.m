//
//  PDRewardTableViewController.m
//  Pods
//
//  Created by John Doran Home on 26/11/2015.
//
//

#import "PDRewardTableViewController.h"
#import "PDRewardListViewModel.h"
#import "PDReward.h"
#import "RewardTableViewCell.h"
#import "NoRewardsTableViewCell.h"
#import "PDAPIClient.h"

@interface PDRewardTableViewController ()
@property (nonatomic, strong)NSArray *rewards;
@end

@implementation PDRewardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];
    
    __weak typeof(self) weakSelf = self;
    [[PDAPIClient sharedInstance]getAllRewardsSuccess:^{
        weakSelf.rewards =  [PDRewardStore allRewards];
        [weakSelf.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
    }];
    
    self.clearsSelectionOnViewWillAppear = NO;
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
    NSLog(@"TODO - NIALL");
}

@end
