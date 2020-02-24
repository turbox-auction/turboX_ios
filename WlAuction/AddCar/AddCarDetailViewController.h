//
//  AddCarDetailViewController.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 04/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VinDetail.h"
#import "Auction.h"

@interface AddCarDetailViewController : UIViewController

@property BOOL isFromDetails;
@property (nonatomic, strong) VinDetail *vinDetail;
@property (nonatomic, strong) Auction *currentAuction;
@end
