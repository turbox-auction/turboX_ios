//
//  DisclosureData.h
//  WlAuction
//
//  Created by Ashutosh Dave on 08/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DisclosureVehicleHistory.h"
#import "DisclosureVehicleDeclaration.h"
#import "DisclosureVehicleCondition.h"
#import "DisclosureAuctionSetting.h"


@interface DisclosureData : JSONModel

@property (nonatomic, strong) DisclosureVehicleHistory *disclosure_vehicle_history;
@property (nonatomic, strong) DisclosureVehicleDeclaration *disclosure_vehicle_declaration;
@property (nonatomic, strong) DisclosureVehicleCondition *disclosure_vehicle_condition;
@property (nonatomic, strong) DisclosureAuctionSetting *disclosure_auction_setting;


@end
