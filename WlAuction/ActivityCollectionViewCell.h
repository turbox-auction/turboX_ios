//
//  ActivityCollectionViewCell.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 04/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblBids;
@property (weak, nonatomic) IBOutlet UILabel *lblVehicleName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIImageView *imgCar;
@property (weak, nonatomic) IBOutlet UILabel *lblCountDown;

@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIButton *postNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;



@end
