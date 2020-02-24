//
//  AllAuctions.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 23/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Auction.h"

@interface AllAuctions : JSONModel

@property (nonatomic, strong) NSArray<Auction,Optional> *activity_auction;
@property (nonatomic, strong) NSArray<Auction,Optional> *buy_pending;
@property (nonatomic, assign) NSNumber <Optional> *per_page_records;
@property (nonatomic, assign) NSNumber <Optional> *per_page_limit;
@property (nonatomic, assign) NSNumber <Optional> *total_records;

@end
