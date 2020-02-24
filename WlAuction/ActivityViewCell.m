//
//  ActivityViewCell.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 02/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "ActivityViewCell.h"
#import "BidHistoryCell.h"
#import "BidHistoryHeaderCell.h"

@interface ActivityViewCell()<UIScrollViewDelegate>
{
    NSMutableArray *arrCollapsed;
    __weak IBOutlet NSLayoutConstraint *tblBidHistoryHeight;
}

- (IBAction)btnExpandClicked:(UIButton *)sender;


@end

@implementation ActivityViewCell

- (void)awakeFromNib {
    // Initialization code
    self.btnPlaceBid.layer.borderColor = [[UIColor blackColor] CGColor];
    self.btnPlaceBid.layer.borderWidth = 1.f;
    self.btnQuickBid.layer.borderColor = [[UIColor blackColor] CGColor];
    self.btnQuickBid.layer.borderWidth = 1.f;
    
    _tblBidHistory.layer.cornerRadius = 5.0;
    _tblBidHistory.clipsToBounds = YES;
    
    _bidHistoryHeader.layer.cornerRadius = 5.0;
    _bidHistoryHeader.clipsToBounds = YES;
    
     arrCollapsed = [NSMutableArray array];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadActivityCell{
    [self.tblBidHistory reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BidHistoryCell"];
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    BidHistoryHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BidHistoryHeaderCell"];
//    cell.btnBidHistory.tag = _superIndex;
//    [cell.btnBidHistory addTarget:self action:@selector(expandHeader:) forControlEvents:UIControlEventTouchUpInside];
//    return cell.contentView;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

#pragma mark - UIScrollView Delegate 
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == _scrollCarImages) {
        CGFloat pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        self.pageControl.currentPage = lround(pageIndex);
    }
}


#pragma mark - Custom Methods
-(void)expandHeader:(UIButton *)sender {
    
   
}

- (IBAction)btnExpandClicked:(UIButton *)sender {
    
    sender.selected=!sender.selected;
    
    [UIView animateWithDuration:0.4 animations:^{
        if (sender.selected) {
            tblBidHistoryHeight.constant = 130;
        }else{
            tblBidHistoryHeight.constant = 0;
        }
        [self.contentView layoutIfNeeded];
        [self.delegate activityCellExpanded:self.superIndex];
    }];
//    NSRange range = NSMakeRange(0, 1);
//    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
//    [self.tblBidHistory reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
}
@end
