//
//  CarPhoto.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 15/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//
#import <UIKit/UIKit.h>
@import Foundation;



@interface CarPhoto : NSObject

// Redeclare all the properties as readwrite for sample/testing purposes.
@property (nonatomic) UIImage *image;
@property (nonatomic) NSData *imageData;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
@property (nonatomic) NSAttributedString *attributedCaptionSummary;
@property (nonatomic) NSAttributedString *attributedCaptionCredit;


@end
