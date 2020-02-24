//
//  UtilityCell.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "UtilityCell.h"

@implementation UtilityCell

- (void)awakeFromNib {
    // Initialization code
    self.imgUtility.layer.borderColor = [[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0] CGColor];
    self.imgUtility.layer.borderWidth = 5.0f;
    self.imgUtility.layer.cornerRadius = self.imgUtility.frame.size.width/2;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
