//
//  AddCarOptionsViewController.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 05/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleDetails.h"

@interface AddCarOptionsViewController : UIViewController

@property (strong, nonatomic) NSString *vehicle_id;
@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSString *car_type;
@end
