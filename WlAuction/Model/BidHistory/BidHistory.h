//
//  BidHistory.h
//  WlAuction
//
//  Created by Ashutosh Dave on 07/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol BidHistory
@end

@interface BidHistory : JSONModel

@property (nonatomic, strong) NSString *bidder_name;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *bidder_country;
@property (nonatomic, strong) NSURL *flag_country;
@property (nonatomic, strong) NSString *bid_amount;
@property (nonatomic, strong) NSString *bid_time;

@end
