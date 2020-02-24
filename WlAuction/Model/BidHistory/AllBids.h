//
//  AllBids.h
//  WlAuction
//
//  Created by Ashutosh Dave on 07/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "BidHistory.h"

@interface AllBids : JSONModel

@property (nonatomic, strong) NSArray<Optional,BidHistory> *bid_history;
@property (nonatomic, strong) NSString<Optional> *vehicle_name;
@property (nonatomic, strong) NSString<Optional> *vehicle_vin;


@end
