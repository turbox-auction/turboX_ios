//
//  DisclosureCell.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 19/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "DisclosureCell.h"
#import "HistoryCell.h"


@implementation DisclosureCell

- (void)awakeFromNib {
    // Initialization code
    // Initialize engine repairs segment
    NSArray *engineRepairSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.engineRepairSegment = [self customizeSegmentControl:self.engineRepairSegment WithArray:engineRepairSegmentItems];
    [self.engineRepairSegment setSelected:YES segmentAtIndex:0];
    
    
    
    
    
    self.outOfProvinceSwitch = [self customizeSegmentControl:self.outOfProvinceSwitch WithArray:engineRepairSegmentItems];
    self.dailyRentalSwitch = [self customizeSegmentControl:self.dailyRentalSwitch WithArray:engineRepairSegmentItems];
    self.fireDamageSwitch = [self customizeSegmentControl:self.fireDamageSwitch WithArray:engineRepairSegmentItems];
    self.immersedInWaterSwitch = [self customizeSegmentControl:self.immersedInWaterSwitch WithArray:engineRepairSegmentItems];
    self.policeCruiserSwitch = [self customizeSegmentControl:self.policeCruiserSwitch WithArray:engineRepairSegmentItems];
    self.taxiLimoSwitch = [self customizeSegmentControl:self.taxiLimoSwitch WithArray:engineRepairSegmentItems];
    self.theftRecoverySwitch = [self customizeSegmentControl:self.theftRecoverySwitch WithArray:engineRepairSegmentItems];
    self.airbagMissingSwitch = [self customizeSegmentControl:self.airbagMissingSwitch WithArray:engineRepairSegmentItems];
    self.totalLossSwitch  = [self customizeSegmentControl:self.totalLossSwitch WithArray:engineRepairSegmentItems];
    
    
//    [self.outOfProvinceSwitch setSelected:YES segmentAtIndex:0];
//    [self.dailyRentalSwitch setSelected:YES segmentAtIndex:0];
//    [self.fireDamageSwitch setSelected:YES segmentAtIndex:0];
//    [self.immersedInWaterSwitch setSelected:YES segmentAtIndex:0];
//    [self.policeCruiserSwitch setSelected:YES segmentAtIndex:0];
//    [self.taxiLimoSwitch setSelected:YES segmentAtIndex:0];
//    [self.theftRecoverySwitch setSelected:YES segmentAtIndex:0];
//    [self.airbagMissingSwitch setSelected:YES segmentAtIndex:0];
//    [self.totalLossSwitch setSelected:YES segmentAtIndex:0];
    
    // Initialize windshield condition segment
    NSArray *windshieldSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Normal" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Chipped" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Cracked" andIcon:nil], nil];
    self.windshieldSegment = [self customizeSegmentControl:self.windshieldSegment WithArray:windshieldSegmentItems];
    [self.windshieldSegment setSelected:YES segmentAtIndex:1];
    
    // Initialize accident brand segment
    NSArray *accidentSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Salvage" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Rebuilt" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Irreparable" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"None" andIcon:nil], nil];
    self.accidentalSegment = [self customizeSegmentControl:self.accidentalSegment WithArray:accidentSegmentItems];
    [self.accidentalSegment setSelected:YES segmentAtIndex:3];
    
    
    // Initialize vehicle lien segment
    NSArray *vehicleLienSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.vehicleLienSegment = [self customizeSegmentControl:self.vehicleLienSegment WithArray:vehicleLienSegmentItems];
    [self.vehicleLienSegment setSelected:YES segmentAtIndex:0];
    
    
    // Initialize pending vehicle Recalls segment
    NSArray *pendingVehicleSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.pendingVehicleSegment = [self customizeSegmentControl:self.pendingVehicleSegment WithArray:pendingVehicleSegmentItems];
    [self.pendingVehicleSegment setSelected:YES segmentAtIndex:0];
    
    
    for (UIView *tempView in _switchView.subviews) {
        if([tempView isKindOfClass:[UISwitch class]]) {
            tempView.tintColor = [UIColor greenColor];
            tempView.layer.cornerRadius = 16;
            tempView.backgroundColor = [UIColor greenColor];
        }
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(PPiFlatSegmentedControl *)customizeSegmentControl:(PPiFlatSegmentedControl *)segmentControl WithArray:(NSArray *) array {
    [segmentControl setItems:array];
    segmentControl.borderWidth = 0.6;
    segmentControl.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    segmentControl.selectedColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    segmentControl.color = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    segmentControl.selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:12],
                                              NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]};
    
    segmentControl.textAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:12],
                                      NSForegroundColorAttributeName:[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0]};
    segmentControl.layer.cornerRadius = 5;
    segmentControl.clipsToBounds = YES;
    [segmentControl setSegmentAtIndex:0 enabled:YES];
    return segmentControl;
}




@end
