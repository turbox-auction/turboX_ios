//
//  BidHistoryViewController.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllBids.h"

@interface BidHistoryViewController : UIViewController

@property (nonatomic, strong) AllBids *allBids;
@property (nonatomic, strong) NSString *vehicleName;
@property (nonatomic, strong) NSString *vinNumber;
@end
