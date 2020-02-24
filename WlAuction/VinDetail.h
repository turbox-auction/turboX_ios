//
//  VinDetail.h
//
//  Created by LiveBird Mac Mini on 23/02/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "JSONModel.h"
#import "CarproofPkg.h"


@interface VinDetail : JSONModel

@property (nonatomic, strong) CarproofPkg *carproofPkg;
@property (nonatomic, strong) NSString *car_type;
@property (nonatomic, strong) NSString *vin;
@property (nonatomic, strong) NSString *modelYear;
@property (nonatomic, strong) NSString *bestMakeName;
@property (nonatomic, strong) NSString *bestModelName;
@property (nonatomic, strong) NSString *cylinders;
@property (nonatomic, strong) NSString *Vehicle_id;
@property (nonatomic, strong) NSString *bodyType;
@property (nonatomic, strong) NSString *gvwr_range_low;
@property (nonatomic, strong) NSString *gvwr_range_high;
@property (nonatomic, strong) NSString *price_msrp;
@property (nonatomic, strong) NSString *price_invoice;
@property (nonatomic, strong) NSString *price_destination;
@property (nonatomic, strong) NSString *engine_type;
@property (nonatomic, strong) NSString *engine_displacement;
@property (nonatomic, strong) NSString *engine_fuel_type;
@property (nonatomic, strong) NSString *engine_horsepower;
@property (nonatomic, strong) NSString *engine_fuel_economy_city_hwy;
@property (nonatomic, strong) NSString *engine_fuel_capacity;
@property (nonatomic, strong) NSString *option_oemcode;
@property (nonatomic, strong) NSString *option_chromecode;
@property (nonatomic, strong) NSString *option_description;
@property (nonatomic, strong) NSString *option_msrp;
@property (nonatomic, strong) NSString *option_invoice;
@property (nonatomic, strong) NSArray *standard_features;
@property (nonatomic, strong) NSString *permission_usmarket;
@property (nonatomic, strong) NSString *error_message;
@property (nonatomic, strong) NSString *is_out_of_stock;
@property (nonatomic, strong) NSString *availability_date;
@property (nonatomic, strong) NSString *mileage;
@property (nonatomic, strong) NSString *vehicle_history;
@property (nonatomic, strong) NSString *mileage_type;
@property (nonatomic, strong) NSString *vehicle_parent_id;
@property (nonatomic, strong) NSString *vehicle_dealer_id;
@property (nonatomic, strong) NSString *passanger_capacity;
@property (nonatomic, strong) NSString *exterior_color;
@property (nonatomic, strong) NSString *interior_color;
@property (nonatomic, strong) NSString *transmission;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *dealer_id;
@property (nonatomic, strong) NSString *carproof_package;
@property (nonatomic, strong) NSString *drivetrain_type;


@end
