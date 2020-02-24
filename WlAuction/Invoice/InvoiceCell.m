//
//  InvoiceCell.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "InvoiceCell.h"

@implementation InvoiceCell

- (void)awakeFromNib {
    // Initialization code
    self.lblInvoiceIndex.layer.borderColor = [[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0] CGColor];
    self.lblInvoiceIndex.layer.borderWidth = 3.0f;
    self.lblInvoiceIndex.layer.cornerRadius = self.lblInvoiceIndex.frame.size.width/2;
    self.lblInvoiceIndex.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
