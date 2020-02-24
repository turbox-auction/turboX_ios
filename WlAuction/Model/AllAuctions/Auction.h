//
//  Auction.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 23/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Auction
@end

@interface Auction : JSONModel

@property (nonatomic, strong) NSString *bid_count;
@property (nonatomic, strong) NSString<Optional> *my_bid;
@property (nonatomic, strong) NSString *vehicle_id;
@property (nonatomic, strong) NSString *auction_id;
@property (nonatomic, strong) NSString *auction_dealer_id;
@property (nonatomic, strong) NSString *car_type;
@property (nonatomic, strong) NSString<Optional> *deleted_by;
@property (nonatomic, strong) NSString<Optional> *vehicle_dealer_id;
@property (nonatomic, strong) NSString<Optional> *dealer_postal_code;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSURL *flag_country;
@property (nonatomic, strong) NSString *dealer_country;
@property (nonatomic, strong) NSString *vehicle_year;
@property (nonatomic, strong) NSString *vehicle_make;
@property (nonatomic, strong) NSString *vehicle_model;
@property (nonatomic, strong) NSString<Optional> *vehicle_mileage;
@property (nonatomic, strong) NSString *mileage_type;
@property (nonatomic, strong) NSString *vehicle_interior_color;
@property (nonatomic, strong) NSString *vehicle_exterior_color;
@property (nonatomic, strong) NSString *vehicle_transmission;
@property (nonatomic, strong) NSURL<Optional> *vehicle_images;
@property (nonatomic, strong) NSString *available_for_bid;
@property (nonatomic, strong) NSString *is_out_of_stock;
@property (nonatomic, strong) NSDate *availability_date;
@property (nonatomic, strong) NSString *bid_received;
@property (nonatomic, strong) NSString *auction_status;
@property (nonatomic, strong) NSURL *video;
@property (nonatomic, strong) NSString *bid_now_button;
@property (nonatomic, strong) NSString *countdown;
@property (nonatomic, strong) NSString<Optional> *vehicle_price;
@property (nonatomic, strong) NSString *created_date;

@end
