//
//  Invoice.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 23/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "WinnerDetails.h"

@protocol Invoice
@end

@interface Invoice : JSONModel

@property (nonatomic, strong) NSString *invoice;
@property (nonatomic, strong) NSString *vehicle_id;
@property (nonatomic, strong) NSString *vehicle_dealer_id;
@property (nonatomic, strong) NSString *dealer_id;
@property (nonatomic, strong) NSString *vehicle_year;
@property (nonatomic, strong) NSString *vehicle_make;
@property (nonatomic, strong) NSString *vehicle_model;
@property (nonatomic, strong) NSURL<Optional> *vehicle_images;
@property (nonatomic, strong) NSString *car_type;
@property (nonatomic, strong) NSArray<WinnerDetails> *winner_detail;
@end
