//
//  DisclosureCell.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 19/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPiFlatSegmentedControl.h"

@interface DisclosureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *engineRepairSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *windshieldSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *accidentalSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *vehicleLienSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *pendingVehicleSegment;



@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *outOfProvinceSwitch;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *dailyRentalSwitch;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *fireDamageSwitch;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *immersedInWaterSwitch;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *policeCruiserSwitch;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *taxiLimoSwitch;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *theftRecoverySwitch;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *airbagMissingSwitch;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *totalLossSwitch;
@property (weak, nonatomic) IBOutlet UIView *switchView;

@property (weak, nonatomic) IBOutlet UITextField *txtTireCondition;
@end


//@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *yesNoSegment;

