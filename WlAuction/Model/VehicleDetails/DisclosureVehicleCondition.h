//
//  DisclosureVehicleCondition.h
//  WlAuction
//
//  Created by Ashutosh Dave on 08/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DisclosureVehicleCondition
@end

@interface DisclosureVehicleCondition : JSONModel

@property (nonatomic, strong) NSString *engine_needs_repair;
@property (nonatomic, strong) NSString *suspension_subframe_needs_repair;
@property (nonatomic, strong) NSString *transmission_needs_repair;
@property (nonatomic, strong) NSString *fuel_system_needs_repair;
@property (nonatomic, strong) NSString *power_train_needs_repair;
@property (nonatomic, strong) NSString *computer_needs_repair;
@property (nonatomic, strong) NSString *electrical_system_needs_repair;
@property (nonatomic, strong) NSString *ac_needs_repair;
@property (nonatomic, strong) NSString *structural_parts_altered;
@property (nonatomic, strong) NSString *windshield_condition;
@property (nonatomic, strong) NSString *tire_condition;


@end
