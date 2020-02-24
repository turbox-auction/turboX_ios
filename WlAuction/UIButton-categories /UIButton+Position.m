//
//  UIButton+Position.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 08/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "UIButton+Position.h"

@implementation UIButton (Position)

-(void) centerButtonAndImageWithSpacing:(CGFloat)spacing {
//    CGFloat insetAmount = spacing / 2.0;
//    self.imageEdgeInsets = UIEdgeInsetsMake(-insetAmount, 0, insetAmount,0);
//    self.titleEdgeInsets = UIEdgeInsetsMake(insetAmount, 0, -insetAmount,0);
//    self.contentEdgeInsets = UIEdgeInsetsMake(insetAmount, 0, insetAmount,0);

    CGSize buttonSize = self.frame.size;
    UIImage *buttonImage = self.imageView.image;
    CGSize buttonImageSize = buttonImage.size;

    
    self.imageEdgeInsets = UIEdgeInsetsMake((buttonSize.height-buttonImageSize.height)/2, (buttonSize.width-buttonImageSize.width)/2, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake((buttonSize.height-buttonImageSize.height)/2 - buttonImageSize.height - spacing - 10, (buttonSize.width-buttonImageSize.width)/2 - buttonImageSize.width - spacing, 0, 0);
//    
//    [_btnAuction setImageEdgeInsets:UIEdgeInsetsMake((buttonSize.height-buttonImageSize.height)/2, (buttonSize.width-buttonImageSize.width)/2, 0, 0)];
//    [_btnAuction setTitleEdgeInsets:UIEdgeInsetsMake((buttonSize.height-buttonImageSize.height)/2 - buttonImageSize.height - 40, (buttonSize.width-buttonImageSize.width)/2 - buttonImageSize.width - 30, 0, 0)];
}

@end
