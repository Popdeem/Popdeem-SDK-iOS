//
//  FriendPickerViewController.m
//  ios-test-v0.2
//
//  Created by Niall Quinn on 02/10/2014.
//  Copyright (c) 2014 Niall Quinn. All rights reserved.
//

#import "PDUIFriendPickerViewController.h"
#import "PDSocialMediaFriend.h"
#import "PDUser.h"
#import "PDUser+Facebook.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface PDUIFriendPickerViewController () {
  
  BOOL searchMode;
  NSMutableArray *_searchData;
  NSMutableArray *_selectedFriends;
  
  float viewHeight;
  
  UIActivityIndicatorView *spinner;
  
  UILabel *selectedFriendsLabel;
  
  UIScrollView *namesScrollView;
  
  IBOutlet UIView *topView;
  __unsafe_unretained IBOutlet UIButton *goButton;
  
	__unsafe_unretained IBOutlet NSLayoutConstraint *topViewHeightConstraint;
  BOOL keyboardIsUp;
  float keyboardHeight;
}

@end

@implementation PDUIFriendPickerViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDUIFriendPickerViewController" bundle:podBundle]) {
    return self;
  }
  return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setNeedsStatusBarAppearanceUpdate];
  _searchData = [NSMutableArray array];
  _selectedFriends = [NSMutableArray array];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  viewHeight = self.view.frame.size.height;
  
  for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
    if (f.selected) {
      [_selectedFriends addObject:f];
    }
  }
	
	topViewHeightConstraint.constant = (_selectedFriends.count > 0) ? 50 : 0;
//  [topView setFrame:CGRectMake(topView.frame.origin.x, topView.frame.origin.y, self.view.frame.size.width, topView.frame.size.height)];
  [_tableView setFrame:CGRectMake(topView.frame.origin.x, topView.frame.origin.y, self.view.frame.size.width, _tableView.frame.size.height)];

  
  [self setTitle:@"Tag Friends"];
  [self reloadTableData];
  // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardDidHideNotification
                                             object:nil];
  [self reloadSelectedFriends];
}

- (void) viewDidAppear:(BOOL)animated {
  [self setupFriendsView];
  [self.view setNeedsDisplay];
}

- (void) keyboardWillHide:(NSNotification*)notification {
  keyboardIsUp = NO;
  [self setupFriendsView];
  
}

- (void) viewWillLayoutSubviews {
	topViewHeightConstraint.constant = (_selectedFriends.count > 0) ? 50 : 0;
	float tabBarHeight = self.tabBarController.tabBar.frame.size.height;
	if (keyboardIsUp) {
		[_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, self.view.frame.size.height-35-keyboardHeight+tabBarHeight)];
	} else {
		[_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, self.view.frame.size.height-35)];
	}
}

- (void) keyboardWillShow:(NSNotification*)notification {
  NSDictionary* d = [notification userInfo];
  CGRect r = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  keyboardHeight = r.size.height;
  keyboardIsUp = YES;
  [self setupFriendsView];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)searchAction:(UITextField*)sender {
  
  if (sender.text.length == 0) {
    searchMode = NO;
    [self.view endEditing:YES];
    [self.tableView reloadData];
    [self setupFriendsView];
    return;
  }
  
  if (_searchData.count > 0) {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
  }
  
  searchMode = YES;
  
  [_searchData removeAllObjects];
  
  NSString *searchString = sender.text;
  
  for (PDSocialMediaFriend *f in _tableData) {
    
    NSRange range = [f.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
      [_searchData addObject:f];
    }
  }
  
  [self setupFriendsView];
  
  [self.view setNeedsDisplay];
  [self reloadTableData];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 1:
      return @"";
      break;
      
    default:
      return @"";
      break;
  }
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  if ([title isEqualToString:@"Selected"]) {
    return 0;
  } else {
    return 1;
  }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  if (searchMode) {
    return _searchData ? _searchData.count : 0;
  } else {
    return _tableData ? _tableData.count : 0;
  }
}

//4
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self imageCell:tableView cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  PDSocialMediaFriend *friend = (searchMode) ? [_searchData objectAtIndex:indexPath.row] : [_tableData objectAtIndex:indexPath.row];
  [friend setSelected:!friend.selected];
  if (friend.selected) {
    [_selectedFriends addObject:friend];
  } else if ([_selectedFriends containsObject:friend]) {
    [_selectedFriends removeObject:friend];
  }
  
  //Update Selected Strings
  [self reloadSelectedFriends];
  [self reloadTableData];
}

-(void) reloadTableData{
  _tableData = [NSMutableArray arrayWithArray:[PDUser taggableFriends]];
  [_tableView reloadData];
  [_tableView reloadInputViews];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 50;
}

- (void) reloadSelectedFriends {
  if (!selectedFriendsLabel) {
    selectedFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 10000, 20)];
  }
  
  [selectedFriendsLabel setFrame:CGRectMake(5, 5, 10000, 20)];
  
  NSMutableString *namesString = [[NSMutableString alloc] init];
  for (PDSocialMediaFriend *selected in _selectedFriends) {
    [namesString appendFormat:@"%@, ",selected.name];
  }
  if (_selectedFriends.count > 0) {
    namesString = [NSMutableString stringWithString:[namesString substringToIndex:namesString.length-1]];
  }
	
  [selectedFriendsLabel removeFromSuperview];
  [selectedFriendsLabel setText:namesString];
  [selectedFriendsLabel setTextColor:[UIColor whiteColor]];
  [selectedFriendsLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  float widthIs = [selectedFriendsLabel.text
                   boundingRectWithSize:selectedFriendsLabel.frame.size
                   options:NSStringDrawingUsesLineFragmentOrigin
                   attributes:@{ NSFontAttributeName:selectedFriendsLabel.font }
                   context:nil].size.width;
  
  widthIs += 5;
  
  [selectedFriendsLabel setFrame:CGRectMake(10, 10, widthIs, 30)];
  
  if (_selectedFriends.count > 0) {
    if (!namesScrollView) {
      
      namesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, 50)];
      [namesScrollView setShowsHorizontalScrollIndicator:NO];
      [topView addSubview:namesScrollView];
      [namesScrollView addSubview:selectedFriendsLabel];
      
    }
    [topView setHidden:NO];
    namesScrollView.contentSize = CGSizeMake(widthIs, 50);
    
    if (widthIs > namesScrollView.frame.size.width) {
      namesScrollView.contentOffset = CGPointMake(widthIs-namesScrollView.frame.size.width,0);
    } else {
      namesScrollView.contentSize = CGSizeMake(0,0);
    }
    
    [namesScrollView addSubview:selectedFriendsLabel];
  } else {
    [topView setHidden:YES];
  }
  [self setupFriendsView];
}

- (IBAction)goButtonPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPressed:(id)sender {
  for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
    if (f.selected) {
      [f setSelected:NO];
    }
  }
  [self dismissViewControllerAnimated:YES completion:NULL];
}

-(UITableViewCell *)imageCell :(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"cell";
  PDSocialMediaFriend *friend;
  
  friend = (searchMode) ? [_searchData objectAtIndex:indexPath.row] : [_tableData objectAtIndex:indexPath.row];
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
  if (friend.selected) {
    [imageView setImage:[UIImage imageNamed:@"pduikit_selectedCheck"]];
  } else {
    [imageView setImage:[UIImage imageNamed:@"pduikit_deselectedCheck"]];
  }
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-55, 50)];
  [label setText:[friend name]];
  
  [cell addSubview:imageView];
  [cell addSubview:label];
  
  return cell;
}

- (IBAction)refreshAction:(id)sender {
  [[PDUser sharedInstance] refreshFacebookFriendsCallback:^(BOOL response){
    if (response == NO) {
      NSLog(@"Something went wrong");
    }else {
      NSLog(@"All good here");
    }
    [spinner stopAnimating];
    _tableData = [NSMutableArray arrayWithArray:[[PDUser sharedInstance] socialMediaFriendsOrderedAlpha]];
    [_searchData removeAllObjects];
    searchMode = NO;
    [self.tableView reloadData];
  }];
  
  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner setCenter:self.view.center];
  [self.view addSubview:spinner];
  [spinner startAnimating];
  [_textField setText:@""];
  
}

- (void) setupFriendsView {
  
  float tabBarHeight = self.tabBarController.tabBar.frame.size.height;
  
  if (_selectedFriends.count > 0) {
		topViewHeightConstraint.constant = 50;
    [topView setFrame:CGRectMake(topView.frame.origin.x, 35, topView.frame.size.width, 50)];
    [topView setHidden:NO];
    if (keyboardIsUp) {
      [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, topView.frame.origin.y+57, _tableView.frame.size.width, self.view.frame.size.height-75-keyboardHeight+tabBarHeight)];
    } else {
      [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, topView.frame.origin.y+57, _tableView.frame.size.width, self.view.frame.size.height-75)];
    }
  } else {
		topViewHeightConstraint.constant = 0;
    [topView setFrame:CGRectMake(topView.frame.origin.x, 35, topView.frame.size.width, 0)];
    if (keyboardIsUp) {
      [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, 35, _tableView.frame.size.width, self.view.frame.size.height-35-keyboardHeight+tabBarHeight)];
    } else {
      [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, topView.frame.origin.y, _tableView.frame.size.width, self.view.frame.size.height-35)];
    }
  }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void) viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
