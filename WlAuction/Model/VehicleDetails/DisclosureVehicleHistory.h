//
//  DisclosureVehicleHistory.h
//  WlAuction
//
//  Created by Ashutosh Dave on 08/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DisclosureVehicleHistory
@end

@interface DisclosureVehicleHistory : JSONModel

@property (nonatomic, strong) NSString *disclosure_id;
@property (nonatomic, strong) NSString *out_of_province_vehicle;
@property (nonatomic, strong) NSString *us_vehicle;
@property (nonatomic, strong) NSString *daily_rental;
@property (nonatomic, strong) NSString *fire_damaged;
@property (nonatomic, strong) NSString *immersed_in_water;
@property (nonatomic, strong) NSString *police_cruiser;
@property (nonatomic, strong) NSString *emergency_services_vehicle;
@property (nonatomic, strong) NSString *tax_or_limo;
@property (nonatomic, strong) NSString *airbag_missing_inoperable;
@property (nonatomic, strong) NSString *anti_lock_brakes_inoperable;
@property (nonatomic, strong) NSString *odometer_rolled_back_replaced;
@property (nonatomic, strong) NSString *theft_recovery;
@property (nonatomic, strong) NSString *total_loss_by_insurer;
@property (nonatomic, strong) NSString *manufacturers_warranty_cancelled;
@property (nonatomic, strong) NSString *any_previous_damage_exceeding_3000;
@property (nonatomic, strong) NSString *manufacturers_badges_decals_changed;
@property (nonatomic, strong) NSString *car_original_specifications_changed;

@end
