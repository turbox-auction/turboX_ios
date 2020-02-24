//
//  SummaryCell.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 19/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPiFlatSegmentedControl.h"
#import "WLAuction-Swift.h"

@interface SummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet SMSegmentView *passengerSegment;

@property (weak, nonatomic) IBOutlet SMSegmentView *transmissionSegment;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *historySegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *milageSegment;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *carproofSegment;

@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UITextField *txtMake;
@property (weak, nonatomic) IBOutlet UITextField *txtModel;
@property (weak, nonatomic) IBOutlet UITextField *txtVin;
@property (weak, nonatomic) IBOutlet UITextField *txtBodyType;
@property (weak, nonatomic) IBOutlet UITextField *txtEngineType;
@property (weak, nonatomic) IBOutlet UITextField *txtFuelType;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (weak, nonatomic) IBOutlet UITextField *txtMileage;
@property (weak, nonatomic) IBOutlet UITextField *txtExtColor;
@property (weak, nonatomic) IBOutlet UITextField *txtIntColor;
@property (weak, nonatomic) IBOutlet UITextField *txtDrivetrain;


// Remove this Field
//@property (weak, nonatomic) IBOutlet UITextField *txtCylinder;
@end
