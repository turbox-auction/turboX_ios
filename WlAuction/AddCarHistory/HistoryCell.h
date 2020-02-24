//
//  HistoryCell.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 07/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPiFlatSegmentedControl.h"

@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UISwitch *btnSwitch;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *yesNoSegment;

@end
