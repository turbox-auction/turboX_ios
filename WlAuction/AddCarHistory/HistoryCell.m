//
//  HistoryCell.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 07/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (void)awakeFromNib {
    // Initialization code
    self.btnSwitch.tintColor = [UIColor greenColor];
    self.btnSwitch.layer.cornerRadius = 16;
//    self.btnSwitch.clipsToBounds = YES;
    self.btnSwitch.backgroundColor = [UIColor greenColor];
    NSArray *historySegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.yesNoSegment = [self customizeSegmentControl:self.yesNoSegment WithArray:historySegmentItems];
    [self.yesNoSegment setTitle:@"No" forSegmentAtIndex:1];

   // [self.yesNoSegment setSegmentAtIndex:1 enabled:YES];

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
    return segmentControl;
}

@end
