//
//  InventoryCell.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 08/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Auction.h"

@interface InventoryCell : UITableViewCell
@property (weak, nonatomic) Auction *objAuction;
@property (weak, nonatomic) IBOutlet UIImageView *imgCar;
@property (weak, nonatomic) IBOutlet UILabel *lblCarName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblBidReceived;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblDealerName;
@property (weak, nonatomic) IBOutlet UILabel *lblMileage;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTransmission;
@property (weak, nonatomic) IBOutlet UILabel *lblColor;
@property (weak, nonatomic) IBOutlet UILabel *lblExtColor;
@property (weak, nonatomic) IBOutlet UILabel *lblIntColor;

@property (weak, nonatomic) IBOutlet UIButton *btnAuction;
@property (weak, nonatomic) IBOutlet UIButton *editBtnAuction;



@property (weak, nonatomic) IBOutlet UIButton *btnHistory;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblCountdown;

@property (weak, nonatomic) IBOutlet UIImageView *imgFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblAuctionState;

@property (weak, nonatomic) IBOutlet UIButton *btnSellThis;
@property (weak, nonatomic) IBOutlet UIButton *btnParkThis;
@property (weak, nonatomic) IBOutlet UIButton *btnRelaunchThis;

@property (weak, nonatomic) IBOutlet UIButton *btnExtra;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *currentDate;

@end
