//
//  DisclosureVehicleDeclaration.h
//  WlAuction
//
//  Created by Ashutosh Dave on 08/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DisclosureVehicleDeclaration
@end

@interface DisclosureVehicleDeclaration : JSONModel

@property (nonatomic, strong) NSString *original_owner;
@property (nonatomic, strong) NSString *original_manufacturer_vin_plate;
@property (nonatomic, strong) NSString *accident_brand;
@property (nonatomic, strong) NSString *repainted;
@property (nonatomic, strong) NSString *vehicle_lien;
@property (nonatomic, strong) NSString *pending_vehicle;
//@property (nonatomic, strong) NSString *asIs_vehicle;


@end
