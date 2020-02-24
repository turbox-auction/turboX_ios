//
//  VehicleDetails.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 04/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DisclosureData.h"
#import "VinDetail.h"
#import "ImageInfo.h"

@interface VehicleDetails : JSONModel

@property (nonatomic, strong) NSString *asIs_vehicle;
@property (nonatomic, strong) NSString *option_description;
@property (nonatomic, strong) NSString *drivetrain_type;

@property (nonatomic, strong) NSString *car_proof_link;
@property (nonatomic, strong) NSString *bidder_id;
@property (nonatomic, strong) NSString *is_favourite;
@property (nonatomic, strong) NSString *bid_count;
@property (nonatomic, strong) NSArray *top_two_bidder;
@property (nonatomic) int quickBidAmt;
@property (nonatomic, strong) NSString *vehicle_price;
@property (nonatomic, strong) NSString *countdown;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSURL *flag_country;
@property (nonatomic, strong) NSString *auction_status;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *dealership_name;
@property (nonatomic, strong) NSString *vehicle_parent_id;
@property (nonatomic, strong) NSString *dealer_state;
@property (nonatomic, strong) NSString *dealer_city;
@property (nonatomic, strong) NSString *dealer_zip;
@property (nonatomic, strong) NSString *dealer_primary_phone;
@property (nonatomic, strong) NSString *vehicle_year;
@property (nonatomic, strong) NSString *vehicle_make;
@property (nonatomic, strong) NSString *vehicle_model;
@property (nonatomic, strong) NSString *vehicle_exterior_color;
@property (nonatomic, strong) NSString *vehicle_mileage;
@property (nonatomic, strong) NSString *mileage_type;
@property (nonatomic, strong) NSString *vehicle_transmission;
@property (nonatomic, strong) NSString *available_for_bid;
@property (nonatomic, strong) NSString *need_reapir;
@property (nonatomic, strong) NSString *us_vehicle;
@property (nonatomic, strong) NSString *windshield_cond;
@property (nonatomic, strong) NSString *accident_brand;
@property (nonatomic, strong) NSString *vehicle_history;
@property (nonatomic, strong) NSString *has_accident;
@property (nonatomic, strong) NSString *odometer_rolled_back_replaced;
@property (nonatomic, strong) NSString *current_bid_amount;
@property (nonatomic, strong) NSString *current_bidder_name;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, strong) NSString *my_bid;
@property (nonatomic, strong) NSMutableArray<ImageInfo,Optional> *images;
@property (nonatomic, strong) NSArray<ImageInfo,Optional> *damaged_pictures;
@property (nonatomic, strong) NSArray *additional_options;
@property (nonatomic, strong) NSArray *standard_features;
@property (nonatomic, strong) VinDetail *inventory_data;

@property (nonatomic, strong) DisclosureData *disclosure_data;

+(VehicleDetails *)sharedInstance;
+(void)resetSharedInstance;

@end
