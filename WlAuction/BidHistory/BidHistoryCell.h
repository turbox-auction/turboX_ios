//
//  BidHistoryCell.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 11/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgFlag;

@property (weak, nonatomic) IBOutlet UILabel *lblBidderName;

@property (weak, nonatomic) IBOutlet UILabel *lblBidAmount;

@property (weak, nonatomic) IBOutlet UILabel *lblBidTime;

@end
