//
//  WinnerDetails.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 23/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol WinnerDetails
@end

@interface WinnerDetails : JSONModel

@property (nonatomic, strong) NSString *dealership_name;
@property (nonatomic, strong) NSString *dealer_country;
@property (nonatomic, strong) NSString *bid_amount;
@property (nonatomic, strong) NSString *bidder_id;
@property (nonatomic, strong) NSURL *bidder_flag_country;

@end
