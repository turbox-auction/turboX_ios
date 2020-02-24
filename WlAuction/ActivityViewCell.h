//
//  ActivityViewCell.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 02/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//
////
#import <UIKit/UIKit.h>

@protocol ActivityCellDelegate <NSObject>

-(void)activityCellExpanded:(NSInteger )index;

@end

@interface ActivityViewCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>{

}

@property (nonatomic, strong) NSMutableArray *arrBidHistory;

@property (weak, nonatomic) IBOutlet UIButton *btnQuickBid;

@property (weak, nonatomic) IBOutlet UIButton *btnPlaceBid;

@property (weak, nonatomic) IBOutlet UITableView *tblBidHistory;

@property (assign, nonatomic) id<ActivityCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *bidHistoryHeader;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollCarImages;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic) NSInteger superIndex;
@end
