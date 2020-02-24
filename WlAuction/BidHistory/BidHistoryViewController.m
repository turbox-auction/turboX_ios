//
//  BidHistoryViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "BidHistoryViewController.h"
#import "BidHistoryCell.h" 
#import "BidHistoryHeaderCell.h"
#import "UIImageView+AFNetworking.h"

@interface BidHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblBidHistory;

@end

@implementation BidHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tabBarController setTitle:@"BID HISTORY"];
    
    // Add bar button items
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allBids.bid_history.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BidHistoryCell"];
    BidHistory *tempBidHistory = [_allBids.bid_history objectAtIndex:indexPath.row];
    [cell.lblBidderName setText:tempBidHistory.bidder_name];
    
    NSString *str = [NSString stringWithFormat:@" %@",tempBidHistory.bid_amount];
    NSArray *stringArray = [str componentsSeparatedByString:@"."];
    NSString* firstBit = [stringArray objectAtIndex: 0];
    
    [cell.lblBidAmount  setText:[NSString stringWithFormat:@"$ %@",firstBit]];
   // [cell.lblBidAmount setText:tempBidHistory.bid_amount];
    [cell.lblBidTime setText:tempBidHistory.bid_time];
    [cell.imgFlag setImageWithURL:tempBidHistory.flag_country];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    BidHistoryHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    [headerCell.lblVehicleName setText:_vehicleName];
    [headerCell.lblVinNumber setText:[[NSString stringWithFormat:@"VIN: %@",_vinNumber] uppercaseString]];
    return headerCell.contentView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

#pragma mark - Custom methods

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
