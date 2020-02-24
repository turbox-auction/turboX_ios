//
//  SummaryCell.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 19/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "SummaryCell.h"

@implementation SummaryCell

- (void)awakeFromNib {
    // Initialization code
    [self.transmissionSegment setDividerColour:[UIColor clearColor]];
  //[self.transmissionSegment separatorColour:[UIColor clearColor]];
    [self.transmissionSegment addSegmentWithTitle:@"A" onSelectionImage:nil offSelectionImage:nil];
    [self.transmissionSegment addSegmentWithTitle:@"M" onSelectionImage:nil offSelectionImage:nil];
    [self.transmissionSegment addSegmentWithTitle:@"S-A" onSelectionImage:nil offSelectionImage:nil];
   //Rajesh [self.transmissionSegment setSegmentTitleFont:[UIFont fontWithName:@"Lato" size:13.0f]];
    [self.transmissionSegment setSelectedSegmentIndex:1];
    
    [self.passengerSegment addSegmentWithTitle:@"2" onSelectionImage:nil offSelectionImage:nil];
    [self.passengerSegment addSegmentWithTitle:@"5" onSelectionImage:nil offSelectionImage:nil];
    [self.passengerSegment addSegmentWithTitle:@"6" onSelectionImage:nil offSelectionImage:nil];
    [self.passengerSegment addSegmentWithTitle:@"7" onSelectionImage:nil offSelectionImage:nil];
    [self.passengerSegment addSegmentWithTitle:@"8+" onSelectionImage:nil offSelectionImage:nil];
    //Rajesh  [self.passengerSegment setSegmentTitleFont:[UIFont fontWithName:@"Lato" size:13.0f]];
    [self.passengerSegment setSelectedSegmentIndex:1];

    NSArray *historySegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.historySegment = [self customizeSegmentControl:self.historySegment WithArray:historySegmentItems];
    
    // Initialize carproof package segment
    NSArray *carproofSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Claims $36" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Verified $51" andIcon:nil], nil];
    self.carproofSegment = [self customizeSegmentControl:self.carproofSegment WithArray:carproofSegmentItems];
    
    // Initialize carproof package segment
    NSArray *mileageSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"miles" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"km" andIcon:nil], nil];
    self.milageSegment = [self customizeSegmentControl:self.milageSegment WithArray:mileageSegmentItems];
    [self.milageSegment setSelected:YES segmentAtIndex:0];
    
    
    
    for (UIView *tempView in self.mainView.subviews) {
        if ([tempView isKindOfClass:[UITextField class]]) {
            [tempView setUserInteractionEnabled:NO];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(PPiFlatSegmentedControl *)customizeSegmentControl:(PPiFlatSegmentedControl *)segmentControl WithArray:(NSArray *) array {
    [segmentControl setItems:array];
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
