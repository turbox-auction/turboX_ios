//
//  AddCarHistoryViewController.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 06/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisclosureVehicleHistory.h"
#import "DisclosureVehicleCondition.h"
#import "DisclosureVehicleDeclaration.h"



@interface AddCarHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblHistory;

@property BOOL isFromDetails;


@property (nonatomic, strong) DisclosureVehicleHistory *disclosure_vehicle_history;
@property (nonatomic, strong) DisclosureVehicleCondition *disclosure_vehicle_condition;
@property (nonatomic, strong) DisclosureVehicleDeclaration *disclosure_vehicle_declaration;




@end
