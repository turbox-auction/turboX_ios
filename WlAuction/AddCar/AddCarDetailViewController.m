//
//  AddCarDetailViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 04/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "AddCarDetailViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "AddCarOptionsViewController.h"
#import "WSLoading.h"
#import "VehicleDetails.h"
#import "AppDelegate.h"
#import "WLAuction-Swift.h"
#import "PPiFlatSegmentedControl.h"

#define BorderColorRef [UIColor blackColor].CGColor
#define SELBorderColorRef [UIColor greenColor].CGColor

//@import SMSegmentView;

@interface AddCarDetailViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate>//SMSegmentViewDelegate
{
    VehicleDetails *vehicleDetails;
    __weak IBOutlet UIView *mainView;
    UIPickerView *yearPicker;
    NSMutableArray *arrYear;

    
    IBOutlet UICollectionView *exteriorCollView;
    IBOutlet UICollectionView *interiorCollView;
    
     NSUInteger  exteriorIndex;
     NSUInteger  interiorIndex;
    
    NSString *exteriorColorStr ;
    
    NSString *interiorColorStr ;
    
    NSString *Drivetrain;
     UIPickerView *drivetrainPicker;
    
    NSArray *exteriorColorsArr ;
    NSArray *interiorColorArr ;
    
    __weak IBOutlet UITextField *txtYear;
    
    __weak IBOutlet UITextField *txtMake;
    
    __weak IBOutlet UITextField *txtModel;
    
    __weak IBOutlet UITextField *txtVinNumber;
    
    __weak IBOutlet UITextField *txtBodyType;
    
    __weak IBOutlet UITextField *txtEngineType;
    
    __weak IBOutlet UITextField *txtFuelType;
    
    __weak IBOutlet UITextView *txtComment;
    
    __weak IBOutlet UITextField *txtMileage;
    
    __weak IBOutlet UILabel *txtPassenger;
    
    __weak IBOutlet UITextField *txtExteriorColor;
    
    __weak IBOutlet UITextField *txtInteriorColor;
    
    NSArray *intercolors;
    NSArray *extercolors;
    
    NSMutableArray *arrDrivetrain;

    
    
    //Remove this field

   // __weak IBOutlet UITextField *txtCylinder;
    
    NSString *numberOfPassenger,*transmission,*history,*carProof,*vehicle_id , *mileagetype;
}


@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *carproofSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *historySegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *mileageSegment;

@property (weak, nonatomic) IBOutlet SMSegmentView *transmissionSegment;
@property (weak, nonatomic) IBOutlet SMSegmentView *passengerSegment;

@property (weak, nonatomic) IBOutlet UITextField *txtDrivetrain;



@end

@implementation AddCarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    exteriorColorStr = @"";
    interiorColorStr  = @"";
    exteriorColorsArr = @[
               [UIColor whiteColor],
               [UIColor blackColor],
               [UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0],
               [UIColor colorWithRed:198/255.0f green:3/255.0f blue:3/255.0f alpha:1.0],
               [UIColor colorWithRed:28/255.0f green:105/255.0f blue:234/255.0f alpha:1.0],
               [UIColor colorWithRed: 168/255.0f green:111/255.0f blue:61/255.0f alpha:1.0],
               [UIColor colorWithRed: 24/255.0f green:165/255.0f blue:14/255.0f alpha:1.0],
               [UIColor colorWithRed: 244/255.0f green:222/255.0f blue:33/255.0f alpha:1.0],
               [UIColor colorWithRed: 246/255.0f green:101/255.0f blue:5/255.0f alpha:1.0],
               [UIColor colorWithRed: 216/255.0f green:216/255.0f blue:216/255.0f alpha:1.0],
               [UIColor colorWithRed: 91/255.0f green:9/255.0f blue:9/255.0f alpha:1.0],
               [UIColor colorWithRed: 151/255.0f green:222/255.0f blue:255/255.0f alpha:1.0],
               [UIColor colorWithRed: 4/255.0f green:126/255.0f blue:87/255.0f alpha:1.0],
               [UIColor colorWithRed: 88/255.0f green:19/255.0f blue:153/255.0f alpha:1.0],
               [UIColor colorWithRed: 197/255.0f green:179/255.0f blue:88/255.0f alpha:1.0]
               
               ];
    
    intercolors = @[@"Black", @"Gray", @"Charcoal",
                     @"White", @"Brown", @"Red", @"Beige"];
    
    extercolors = @[@"White", @"Black", @"Gary",
                    @"Red", @"Blue", @"Green", @"Yellow", @"Orange", @"Silver", @"Burgundy", @"Light Blue",@"Teal",@"Purple",@"Gold"];
    
    interiorColorArr = @[
                          [UIColor blackColor],
                          [UIColor colorWithRed: 200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0],
                          [UIColor colorWithRed: 70/255.0f green:70/255.0f blue:70/255.0f alpha:1.0],
                          [UIColor whiteColor],
                          [UIColor colorWithRed: 155/255.0f green:75/255.0f blue:21/255.0f alpha:1.0],
                          [UIColor colorWithRed: 158/255.0f green:38/255.0f blue:38/255.0f alpha:1.0],
                          [UIColor colorWithRed: 245/255.0f green:245/255.0f blue:220/255.0f alpha:1.0]
                        
                          ];
    
    
   
     arrDrivetrain = [NSMutableArray arrayWithObjects:@"2WD",@"4WD",@"AWD",@"FWD",@"RWD", nil];
    
    [self.transmissionSegment addSegmentWithTitle:@"A" onSelectionImage:nil offSelectionImage:nil];
    [self.transmissionSegment addSegmentWithTitle:@"M" onSelectionImage:nil offSelectionImage:nil];
    [self.transmissionSegment addSegmentWithTitle:@"S-A" onSelectionImage:nil offSelectionImage:nil];
    [_transmissionSegment setSelectedSegmentIndex:0];

    
    [self.passengerSegment addSegmentWithTitle:@"2" onSelectionImage:nil offSelectionImage:nil];
    [self.passengerSegment addSegmentWithTitle:@"5" onSelectionImage:nil offSelectionImage:nil];
    [self.passengerSegment addSegmentWithTitle:@"6" onSelectionImage:nil offSelectionImage:nil];
    [self.passengerSegment addSegmentWithTitle:@"7" onSelectionImage:nil offSelectionImage:nil];
    [self.passengerSegment addSegmentWithTitle:@"8+" onSelectionImage:nil offSelectionImage:nil];
    [_passengerSegment setSelectedSegmentIndex:0];
    
    
    drivetrainPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 150.0f)];
    [drivetrainPicker setDataSource: self];
    [drivetrainPicker setDelegate: self];
    drivetrainPicker.showsSelectionIndicator = NO;
    drivetrainPicker.translatesAutoresizingMaskIntoConstraints = NO;
    _txtDrivetrain.inputView = drivetrainPicker;


    history = @"yes";
    mileagetype = @"miles";

//    carProof = @"claims";
    numberOfPassenger = @" ";
    transmission = @" ";
    
     Drivetrain = @"0";
    
    // Initialize history segment
    
    
    NSArray *historySegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.historySegment = [self customizeSegmentControl:self.historySegment WithArray:historySegmentItems];

    
    // Initialize carproof package segment
    NSArray *carproofSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Claims $36" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Verified $51" andIcon:nil], nil];
    self.carproofSegment = [self customizeSegmentControl:self.carproofSegment WithArray:carproofSegmentItems];
    [self.carproofSegment setSelected:YES segmentAtIndex:9999];
    
    
    
    NSArray *mileageSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"miles" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"km" andIcon:nil], nil];
    self.mileageSegment = [self customizeSegmentControl:self.mileageSegment WithArray:mileageSegmentItems];
    [self.mileageSegment setSelected:YES segmentAtIndex:0];

    

    if(_vinDetail) {
        [self loadVinDetail];
    }else {
        [self getVehicleDetails];
    }
    
}





-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
        yearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 150)];
    [yearPicker setDataSource: self];
    [yearPicker setDelegate: self];
    yearPicker.showsSelectionIndicator = NO;
    txtYear.inputView = yearPicker;
    
    arrYear = [NSMutableArray array];
    for(int i=1970; i<2016;i++){
        [arrYear addObject:[NSString stringWithFormat:@"%d",i]];
    }
    UIColor *placeholderColor = [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1.0];
    //    txtYear.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtYear.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    for (UIView *tempView in mainView.subviews) {
        if([tempView isKindOfClass:[UITextField class]]) {
            [self setTextField:(UITextField *)tempView PlaceholderWithColor:placeholderColor];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.tabBarController.title = @"SELL DETAILS";
        // Add bar button items
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"true_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(loadOptionalView:)];
    
    if(!_isFromDetails) {
        
        self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButton;
    }
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [self.historySegment setSelected:YES segmentAtIndex:1];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
}





#pragma mark - UIButton methods
- (IBAction)btnYearClicked:(id)sender {
    [txtYear becomeFirstResponder];
}

- (IBAction)btnDrivetrainClicked:(id)sender {
    [_txtDrivetrain becomeFirstResponder];
}






/*- (IBAction)colorBtnClick:(id)sender {
    exteriorColorStr = @"black";
    
    colourBtn.layer.borderColor = BorderColorRef;
    colorBtn1.layer.borderColor = BorderColorRef;
    colorBtn2.layer.borderColor = BorderColorRef;
    colorBtn3.layer.borderColor = BorderColorRef;
    colorBtn4.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;


}
- (IBAction)grayBtnClick:(id)sender {
     exteriorColorStr = @"gray";
    colourBtn.layer.borderColor = BorderColorRef;
    colorBtn1.layer.borderColor = BorderColorRef;
    colorBtn2.layer.borderColor = BorderColorRef;
    colorBtn3.layer.borderColor = BorderColorRef;
    colorBtn4.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;

    
}
- (IBAction)yellowBtnClick:(id)sender {
     exteriorColorStr = @"yellow";
    colourBtn.layer.borderColor = BorderColorRef;
    colorBtn1.layer.borderColor = BorderColorRef;
    colorBtn2.layer.borderColor = BorderColorRef;
    colorBtn3.layer.borderColor = BorderColorRef;
    colorBtn4.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;
    
}
- (IBAction)redBtnClick:(id)sender {
     exteriorColorStr = @"red";
    colourBtn.layer.borderColor = BorderColorRef;
    colorBtn1.layer.borderColor = BorderColorRef;
    colorBtn2.layer.borderColor = BorderColorRef;
    colorBtn3.layer.borderColor = BorderColorRef;
    colorBtn4.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;
    
}
- (IBAction)whiteBtnClick:(id)sender {
     exteriorColorStr = @"white";
    colourBtn.layer.borderColor = BorderColorRef;
    colorBtn1.layer.borderColor = BorderColorRef;
    colorBtn2.layer.borderColor = BorderColorRef;
    colorBtn3.layer.borderColor = BorderColorRef;
    colorBtn4.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;

}
- (IBAction)blackBtnClick:(id)sender {
    interiorColorStr = @"black";
    
    colorBtn5.layer.borderColor = BorderColorRef;
    colorBtn6.layer.borderColor = BorderColorRef;
    colorBtn7.layer.borderColor = BorderColorRef;
    colorBtn8.layer.borderColor = BorderColorRef;
    colorBtn9.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;

}
- (IBAction)brownBtnClick:(id)sender {
    interiorColorStr = @"brown";
    colorBtn5.layer.borderColor = BorderColorRef;
    colorBtn6.layer.borderColor = BorderColorRef;
    colorBtn7.layer.borderColor = BorderColorRef;
    colorBtn8.layer.borderColor = BorderColorRef;
    colorBtn9.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;
}
- (IBAction)lightGrayBtnClick:(id)sender {
    interiorColorStr = @"gray";
    
    colorBtn5.layer.borderColor = BorderColorRef;
    colorBtn6.layer.borderColor = BorderColorRef;
    colorBtn7.layer.borderColor = BorderColorRef;
    colorBtn8.layer.borderColor = BorderColorRef;
    colorBtn9.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;

}
- (IBAction)creamBtnClick:(id)sender {
    interiorColorStr = @"cream";
    colorBtn5.layer.borderColor = BorderColorRef;
    colorBtn6.layer.borderColor = BorderColorRef;
    colorBtn7.layer.borderColor = BorderColorRef;
    colorBtn8.layer.borderColor = BorderColorRef;
    colorBtn9.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;

}
- (IBAction)whiteBtnClk:(id)sender {
    interiorColorStr = @"white";
    colorBtn5.layer.borderColor = BorderColorRef;
    colorBtn6.layer.borderColor = BorderColorRef;
    colorBtn7.layer.borderColor = BorderColorRef;
    colorBtn8.layer.borderColor = BorderColorRef;
    colorBtn9.layer.borderColor = BorderColorRef;
    UIButton *btn =  (UIButton *)sender;
    btn.layer.borderColor = SELBorderColorRef;

}
*/

- (IBAction)btnNextClicked:(id)sender {
    
    if(txtMileage.text.length == 0) {
        [WSLoading showAlertWithTitle:@"Error" Message:@"Mileage cannot be empty"];
        return;
    }
    if(carProof.length == 0) {
        [WSLoading showAlertWithTitle:@"Error" Message:@"Please select CarProof option"];
        return;
    }
    transmission = [@[@"auto",@"manual",@"semi-auto"] objectAtIndex:_transmissionSegment.selectedSegmentIndex];
    
    numberOfPassenger = [@[@"2",@"5",@"6",@"7",@"8+"] objectAtIndex:_passengerSegment.selectedSegmentIndex];


    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _vinDetail.car_type,@"car_type",
                            txtYear.text,@"model_year",
                            _txtDrivetrain.text,@"drivetrain_type",
                            txtMake.text,@"bestmaker_name",
                            txtModel.text,@"bestmodel_name",
                            _vinDetail.vin,@"vin_id",
                            txtBodyType.text,@"body_type",
                            txtEngineType.text,@"engine_type",
                            txtFuelType.text,@"engine_fuel_type",
                            //txtComment.text,@"option_description",
                            txtMileage.text,@"vehicle_mileage",
                            mileagetype,@"mileage_type",
                            interiorColorStr,@"vehicle_interior_color",
                            exteriorColorStr,@"vehicle_exterior_color",
                            numberOfPassenger,@"vehicle_passanger_capacity",
                            transmission,@"vehicle_transmission",
                            history,@"vehicle_history",
                            carProof,@"carproof_package"
                            ,nil];
//    NSDictionary *headers = [NSDictionary dictionaryWithObject:[WSLoading getCurrentUserDetailForKey:@"auth_key"] forKey:@"AUTH_KEY"];

    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,SAVE_SUMMARY];
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
//        [WSLoading showLoading];
        NSError* error;
       NSString *jsonStr = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&error];
        NSLog(@"save summary JSON:%@",jsonStr);
        vehicle_id = [json objectForKey:@"vehicle_id"];
        if(vehicle_id.length > 0) {
//            [WSLoading dismissLoading];
            setObjectInUserDefaults(@"usMarket", _vinDetail.permission_usmarket);

            setObjectInUserDefaults(@"vehicle_id", vehicle_id);
            NSString *tempName = [NSString stringWithFormat:@"%@ %@ %@",txtYear.text,txtMake.text,txtModel.text];
            setObjectInUserDefaults(@"vehicleName",tempName);
            
            if(_vinDetail.standard_features.count > 0) {
                [self saveFeaturesWithVehicleId:[json objectForKey:@"vehicle_id"]];
            }else {
                [WSLoading dismissLoading];
                setObjectInUserDefaults(@"vin_id", vehicleDetails.inventory_data.vin);
                NSString *tempName = [NSString stringWithFormat:@"%@ %@ %@",vehicleDetails.vehicle_year,vehicleDetails.vehicle_make,vehicleDetails.vehicle_model];
                setObjectInUserDefaults(@"vehicleName",tempName);

                AddCarOptionsViewController *addCarOptions = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarOptionsViewController"];
                addCarOptions.options = [NSMutableArray arrayWithArray:vehicleDetails.additional_options];
                setObjectInUserDefaults(@"car_type", _vinDetail.car_type);
                [self.navigationController pushViewController:addCarOptions animated:YES];
            }
        }else {
           [WSLoading dismissLoading];
//            [WSLoading showAlertWithTitle:@"Error" Message:json];
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:[json objectForKey:@"error_message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:successAlert animated:YES completion:nil];
            NSLog(@"Error:%@",error.localizedDescription);
        }
        
    }];
    
    
}

#pragma mark - Custom Methods

-(void)getVehicleDetails {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _currentAuction.vehicle_id,@"vehicle_id",
                            _currentAuction.car_type,@"car_type",
                            _currentAuction.auction_id,@"auction",
                            _currentAuction.dealer_country,@"dealer_country",
                            nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,VEHICLE_DETAILS];
    
    
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError *error;
        [VehicleDetails resetSharedInstance];
        vehicleDetails = [[VehicleDetails alloc]initWithData:result error:&error];
        [WSLoading saveCurrentVehicleDetails:vehicleDetails];
        if(!error) {
            _vinDetail = vehicleDetails.inventory_data;
            [self loadVinDetail];
            if([vehicleDetails.vehicle_transmission isEqualToString:@"manual"]) {
                [_transmissionSegment setSelectedSegmentIndex:1];
            } else if([vehicleDetails.vehicle_transmission isEqualToString:@"auto"]) {
                [_transmissionSegment setSelectedSegmentIndex:0];
            }else if([vehicleDetails.vehicle_transmission isEqualToString:@"semi-auto"]) {
                [_transmissionSegment setSelectedSegmentIndex:2];
            } else {
                [_transmissionSegment setSelectedSegmentIndex:0];
            }
           //
        }
    }];
}


#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == exteriorCollView) {
        return exteriorColorsArr.count ;
    }
    else{
       return interiorColorArr.count ;
        
    }

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == exteriorCollView)
    {
        UICollectionViewCell *exteriorColorCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExteriorCell" forIndexPath:indexPath];
        
        UIView *exteriorView = (UIView*)[exteriorColorCell viewWithTag:11];
        
        exteriorView.layer.cornerRadius = exteriorView.bounds.size.width/2;
        exteriorView.layer.borderWidth = 2.0f;
        
        if (exteriorIndex == [indexPath row]+1) {
            exteriorView.layer.borderColor = SELBorderColorRef;

        } else {
            exteriorView.layer.borderColor = BorderColorRef;

        }
        
         exteriorView.backgroundColor = exteriorColorsArr[indexPath.item];
    //
        return exteriorColorCell;
}
    else
    {
        UICollectionViewCell *interiorColorCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InteriorCell" forIndexPath:indexPath];
        
        UIView *interiorView = (UIView*)[interiorColorCell viewWithTag:22];
    
        interiorView.layer.cornerRadius = interiorView.bounds.size.width/2;
        interiorView.layer.borderWidth = 2.0f;
        if (  interiorIndex == [indexPath row]+1) {
            interiorView.layer.borderColor = SELBorderColorRef;
            
        } else {
            interiorView.layer.borderColor = BorderColorRef;
            
            
        }
        
        interiorView.backgroundColor = interiorColorArr[indexPath.item];
      
          return interiorColorCell;
    }
    
    // return the cell
    
  
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == exteriorCollView)
    {
        exteriorIndex = [indexPath row]+1;
        int itemNo = (int)[indexPath row]+1;
       //UICollectionViewCell *exteriorColorCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExteriorCell" forIndexPath:indexPath];
        
        switch (itemNo) {
            case 1:
            {
               
                exteriorColorStr = @"White";
                break;
            }
            case 2:
            {
                exteriorColorStr = @"Black";
                break;
            }
            case 3:
            {
                exteriorColorStr = @"Gray";
                break;
            }
            case 4:
            {
                exteriorColorStr = @"Red";
                break;
            }
            case 5:
            {
                exteriorColorStr = @"Blue";
                break;
            }

            case 6:
            {
                exteriorColorStr = @"Green";
                break;
            }
            case 7:
            {
                exteriorColorStr = @"Yellow";
                break;
            }
            case 8:
            {
                exteriorColorStr = @"Orange";
                break;
            }
            case 9:
            {
                exteriorColorStr = @"Silver";
                break;
            }
            case 10:
            {
                exteriorColorStr = @"Burgundy";
                break;
            }
            case 11:
            {
                exteriorColorStr = @"Light Blue";
                break;
            }
            case 12:
            {
                exteriorColorStr = @"Teal";
                break;
            }
            case 13:
            {
                exteriorColorStr = @"Purple";
                break;
            }
            case 14:
            {
                exteriorColorStr = @"Gold";
                break;
            }
            
           
                
        }
        
    }else{
        interiorIndex = [indexPath row]+1;
        int itemNo = (int)[indexPath row]+1;
        switch (itemNo) {
            case 1:
            {
               
                interiorColorStr = @"Black";
                break;
            }
            case 2:
            {
                interiorColorStr = @"Gray";
                break;
            }
            case 3:
            {
                interiorColorStr = @"Charcoal";
                break;
            }
            case 4:
            {
                interiorColorStr = @"White";
                break;
            }
            
            case 5:
            {
                interiorColorStr = @"Brown";
                break;
            }
            case 6:
            {
                exteriorColorStr = @"Red";
                break;
            }
            case 7:
            {
                exteriorColorStr = @"Beige";
                break;
            }
           
                
        }
    }
    [collectionView reloadData];
}
/*
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor redColor];
    UIView *interiorView = (UIView*)[cell.contentView viewWithTag:22];
    interiorView.layer.borderColor = SELBorderColorRef;
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIView *interiorView = (UIView*)[cell.contentView viewWithTag:22];
    interiorView.layer.borderColor = BorderColorRef;
    
}*/


-(void)loadVinDetail {
    [txtYear setText:_vinDetail.modelYear];
    [txtMake setText:_vinDetail.bestMakeName];
    [txtModel setText:_vinDetail.bestModelName];
    [txtVinNumber setText:_vinDetail.vin];
    [txtBodyType setText:_vinDetail.bodyType];
    [txtEngineType setText:_vinDetail.engine_type];
    [txtFuelType setText:_vinDetail.engine_fuel_type];
   // [txtComment setText:_vinDetail.option_description];
   [_txtDrivetrain setText:[NSString stringWithFormat:@"%@",vehicleDetails.drivetrain_type]];
    
//    if(txtComment.text.length == 0) {
//        [txtComment setText:@"Comments"];
//    }
     //[txtMileage setText:_vinDetail.engine_fuel_economy_city_hwy];
    //[txtCylinder setText:_vinDetail.cylinders];
    
    [txtMileage setText:_vinDetail.mileage];
    
//    [txtExteriorColor setText:_vinDetail.exterior_color];
//    [txtInteriorColor setText:_vinDetail.interior_color];
    
    
  
    exteriorIndex = [extercolors indexOfObject:_vinDetail.exterior_color];
    if (exteriorIndex >= [extercolors count]){
        exteriorIndex = 0;
    } else {
        exteriorIndex += 1;

    }
    
    interiorIndex = [intercolors indexOfObject:_vinDetail.interior_color];
    if (interiorIndex >= [intercolors count]){
        interiorIndex = 0;
    } else {
        interiorIndex += 1;
        
    }

    [exteriorCollView reloadData];
    [interiorCollView reloadData];
 
    
    //[txtCylinder setText:_vinDetail.cylinders];

    //for (SMSegment *segment in [_passengerSegment segments]) {
        for (SMSegment *segment in _passengerSegment.segments) {
        if ([segment.title isEqualToString:_vinDetail.passanger_capacity]){
            [_passengerSegment setSelectedSegmentIndex:segment.index];


        }
    }

    
    mileagetype = _vinDetail.mileage_type;
    if (![mileagetype length]){
        mileagetype = @"miles";
    }
    if([mileagetype isEqualToString:@"miles"]) {
        [_mileageSegment setSelected:YES segmentAtIndex:0];
    }else {
        [_mileageSegment setSelected:YES segmentAtIndex:1];
    }
    
    history = _vinDetail.vehicle_history;
    if (![history length]){
        history = @"no";
    }
    
    if([_vinDetail.vehicle_history isEqualToString:@"no"]) {
        [_historySegment setSelected:YES segmentAtIndex:1];
    }else {
        [_historySegment setSelected:YES segmentAtIndex:0];
    }
    
    if([_vinDetail.carproof_package isEqualToString:@"claims"]) {
        [_carproofSegment setSelected:YES segmentAtIndex:0];
    }else if([_vinDetail.carproof_package isEqualToString:@"verified"]) {
        [_carproofSegment setSelected:YES segmentAtIndex:1];
    }else {
        [_carproofSegment setSelected:YES segmentAtIndex:9999];
    }
    carProof = _vinDetail.carproof_package;
    

}

-(void)saveFeaturesWithVehicleId:(NSString *)vehicleId {
    
    
    NSError *error;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:_vinDetail.standard_features options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            jsonString, @"feature_options",
                            vehicleId,@"vehicle_id",
                            _vinDetail.car_type,@"car_type",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,SAVE_FEATURES];
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
//        NSString *json = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        NSLog(@"save features JSON:%@",json);
        
          if([[json objectForKey:@"success"] isEqualToString:@"true"]){
//        if(!error) {
            AddCarOptionsViewController *addCarOptions = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarOptionsViewController"];
            setObjectInUserDefaults(@"car_type", _vinDetail.car_type);
            [self.navigationController pushViewController:addCarOptions animated:YES];
        }

    }];
    
    
}

-(void)setTextField:(UITextField *)textField PlaceholderWithColor:(UIColor *)color {
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
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
    if(segmentControl != self.carproofSegment){
        [segmentControl setSegmentAtIndex:0 enabled:YES];
    }else {
        [segmentControl setSelected:YES segmentAtIndex:9999];
    }
    return segmentControl;
}

-(void)loadOptionalView:(id)sender {
    [self btnNextClicked:sender];
}

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView Datasource

#pragma mark - UIPickerView Datasource


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView==yearPicker){
     return [arrYear count];
    }else{
        
        return [arrDrivetrain count];
    }
   
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
     if(pickerView==yearPicker){
    return [arrYear objectAtIndex:row];
     }else{
    return [arrDrivetrain objectAtIndex:row];
     }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView==yearPicker){
    txtYear.text = [arrYear objectAtIndex:row];
    }else{
    _txtDrivetrain.text = [arrDrivetrain objectAtIndex:row];
    Drivetrain = [NSString stringWithFormat:@"%ld",(long)row+1];
    }
}

#pragma mark - UITextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Comments"]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@""]) {
        textView.text = @"Comments";
    }
    [textView resignFirstResponder];
}

#pragma mark - SMSegment Delegate
-(void)segmentView:(SMBasicSegmentView *)segmentView didselectSegmentAtIndexWithIndex:(NSInteger)index {
    if(segmentView == self.passengerSegment) {
        numberOfPassenger = [(SMSegment *)[[segmentView segments] objectAtIndex:index] title];
    }
    if(segmentView == self.transmissionSegment) {
        transmission = [@[@"auto",@"manual",@"semi-auto"] objectAtIndex:index];
    }
}



-(IBAction)segmentValueChanged:(PPiFlatSegmentedControl *)sender {
    if(sender == _historySegment) {
        if(sender.selectedSegmentIndex == 0) {
           history = @"yes";
        }else {
            history = @"no";
        }
    }else if(sender == _mileageSegment) {
        if(sender.selectedSegmentIndex == 0) {
            mileagetype = @"miles";
        }else {
            mileagetype = @"km";
        }
    }else {
        if(sender.selectedSegmentIndex == 0) {
            carProof = @"claims";
        }else {
            carProof = @"verified";
        }
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
