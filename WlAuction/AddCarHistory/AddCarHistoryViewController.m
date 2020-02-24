//
//  AddCarHistoryViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 06/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "AddCarHistoryViewController.h"
#import "AddCarDeclarationVC.h"
#import "HistoryCell.h"
#import "PPiFlatSegmentedControl.h"
#import "WSLoading.h"
#import <JSONModel/JSONModel.h>

#import "DisclosureVehicleDeclaration.h"
#import "DisclosureData.h"


@interface AddCarHistoryViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    NSMutableDictionary *historyData;
    NSArray *arrHistory,*arrHistoryKey;
    UIPickerView *tirePicker;
    UIDatePicker *datePicker;
    NSMutableArray *arrTire;
    NSString *engineRepairs,*windShieldCondition,*accidentBrand,*vehicleLien,*pendingVehicle,*tireCondition,*usMarket,*caMarket,*outOfStock ,*dateString,*timeString, *postType,*postLatter,*asISVEHICLE;
    UIBarButtonItem *rightBarButton;
    __weak IBOutlet UIView *dateView;
    __weak IBOutlet NSLayoutConstraint *dateViewHeightConstraint;
    
       DisclosureData *disclosure_data;
       NSUInteger  dataIndex;
    
}

@property (weak, nonatomic) IBOutlet UITextField *txtDateOfAvailability;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *engineRepairSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *windshieldSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *accidentSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *vehicleLienSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *pendingVehicleSegment;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *asIsVehicleSegment;

 @property (weak, nonatomic) IBOutlet UITextView *txtComment;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *marketSegment;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *outOfStockSegment;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *postLatterSegment;

@property (weak, nonatomic) IBOutlet UITextField *txtTireCondition;

@property (weak, nonatomic) IBOutlet UITextField *txtReservePrice;
@property (weak, nonatomic) IBOutlet UIButton *btnAgreeDisclosure;

@property (weak, nonatomic) IBOutlet UIButton *btnPostToAuction;

@property (weak, nonatomic) IBOutlet UIButton *btnAgree;

@property (weak, nonatomic) IBOutlet UIButton *btnParkVechile;
@property (weak, nonatomic) IBOutlet UIButton *btnScheduleVechile;
@property (weak, nonatomic) IBOutlet UITextField *scheduleTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *scheduleLineImage;



@end

@implementation AddCarHistoryViewController

@synthesize disclosure_vehicle_declaration;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_btnPostToAuction setHidden:YES];
    [_btnParkVechile setHidden:YES];
    [_btnScheduleVechile setHidden:YES];
    [self.tabBarController setTitle:@"SELL DETAILS"];
//    _tblHistory.est = 600;
//    _tblHistory.rowHeight = UITableViewAutomaticDimension;
    
    arrHistory = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"History" ofType:@"plist"]];
    
    arrTire = [NSMutableArray arrayWithObjects:@"Good",@"Average",@"Need 1 Tire",@"Need 2 Tire",@"Need 3 Tire",@"Need 4 Tire", nil];
    
    [_btnPostToAuction.layer setCornerRadius:5];
    [_btnPostToAuction setClipsToBounds:YES];
    
    [_btnParkVechile.layer setCornerRadius:5];
    [_btnParkVechile setClipsToBounds:YES];
    
    [_btnScheduleVechile.layer setCornerRadius:5];
    [_btnScheduleVechile setClipsToBounds:YES];
    
    arrHistoryKey = [NSArray arrayWithObjects:@"histroy_data[out_of_province_vehicle]",@"histroy_data[daily_rental]",@"histroy_data[fire_damaged]",@"histroy_data[immersed_water]",@"histroy_data[police_cruiser]",@"histroy_data[tax_limo]",@"histroy_data[theft_recovery]",@"histroy_data[airbag_missing]",@"histroy_data[total_loss_by_insurer]", nil];
    
    historyData = [NSMutableDictionary dictionary];
    
    
    engineRepairs =  @"off";
    windShieldCondition = @"0";
    tireCondition = @"0";
    accidentBrand = @"";
    vehicleLien = @"off";
    pendingVehicle = @"off";
    asISVEHICLE = @"off";
    
    
    NSLog(@"%@ [VehicleDetails sharedInstance]", [VehicleDetails sharedInstance].disclosure_data.disclosure_vehicle_history);
    NSLog(@"%@ [VehicleDetails sharedInstance]", [VehicleDetails sharedInstance].disclosure_data.disclosure_vehicle_declaration);
    NSLog(@"%@ [VehicleDetails sharedInstance]", [VehicleDetails sharedInstance].disclosure_data.disclosure_vehicle_condition);
    NSLog(@"%@ [VehicleDetails sharedInstance]", [VehicleDetails sharedInstance].disclosure_data.disclosure_auction_setting);
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    [datePicker setMinimumDate: [NSDate date]];
    [self.scheduleTimeTextField setInputView:datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelDatePicker)];
    [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,doneBtn, nil]];
    [self.scheduleTimeTextField setInputAccessoryView:toolBar];


}

-(void) cancelDatePicker{
   [self.scheduleTimeTextField resignFirstResponder];
}


-(void)ShowSelectedDate
{   NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MMM-YYYY hh:mm a"];
    self.scheduleTimeTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.scheduleTimeTextField resignFirstResponder];
    
    
    NSString * mainString = self.scheduleTimeTextField.text;
    NSArray * array = [mainString componentsSeparatedByString:@" "];
    NSLog(@"Expected string is : %@",array);
    dateString = array[0];
    NSString *new1 = array[1];
    NSString *new = array[2];
    timeString = [new1 stringByAppendingString:new];
    NSLog(@"date: %@, time: %@", dateString, timeString);
}




-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.tabBarController.title = @"SELL DETAILS";
    UIView *header = self.tblHistory.tableFooterView;
    
    dateString = @"";
    timeString = @"";
    postType = @"";
    
    [header setNeedsLayout];
    [header layoutIfNeeded];
    
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = header.frame;
    
    frame.size.height = height + 40;
    header.frame = frame;
    
    self.tblHistory.tableFooterView = header;
    
    // Add bar button items
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
    
    rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"true_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(loadDeclaration:)];
    [rightBarButton setEnabled:NO];
    [_btnPostToAuction setHidden:YES];
     [_btnParkVechile setHidden:YES];
     [_btnScheduleVechile setHidden:YES];
    if(!_isFromDetails) {
//        [_btnPostToAuction setHidden:NO];
        self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButton;
    }
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    // Initialize engine repairs segment
    NSArray *engineRepairSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.engineRepairSegment = [self customizeSegmentControl:self.engineRepairSegment WithArray:engineRepairSegmentItems];
//    self.engineRepairSegment 
    
    // Initialize windshield condition segment
    NSArray *windshieldSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Normal" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Chipped" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Cracked" andIcon:nil], nil];
    self.windshieldSegment = [self customizeSegmentControl:self.windshieldSegment WithArray:windshieldSegmentItems];
    [self.windshieldSegment setSelected:YES segmentAtIndex:0];
    
    // Initialize accident brand segment
    NSArray *accidentSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Salvage" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Rebuilt" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Irreparable" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"None" andIcon:nil], nil];
    self.accidentSegment = [self customizeSegmentControl:self.accidentSegment WithArray:accidentSegmentItems];
    
    // Initialize vehicle lien segment
    NSArray *vehicleLienSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.vehicleLienSegment = [self customizeSegmentControl:self.vehicleLienSegment WithArray:vehicleLienSegmentItems];
    // [self.vehicleLienSegment setSelected:YES segmentAtIndex:0];
    
    // Initialize pending vehicle Recalls segment
    NSArray *pendingVehicleSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.pendingVehicleSegment = [self customizeSegmentControl:self.pendingVehicleSegment WithArray:pendingVehicleSegmentItems];
     //[self.pendingVehicleSegment setSelected:YES segmentAtIndex:0];
    
    NSArray *asIsVehicleSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self. asIsVehicleSegment = [self customizeSegmentControl:self. asIsVehicleSegment WithArray:asIsVehicleSegmentItems];
   
    
    // Initialize market segment
    NSArray *marketSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"U.S." andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Canada" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Both" andIcon:nil], nil];
    self.marketSegment = [self customizeSegmentControl:self.marketSegment WithArray:marketSegmentItems];
    
    if([[WSLoading getUserDefaultValueFromKey:@"usMarket"]  isEqual: @"1"]) {
        [self.marketSegment setSelected:YES segmentAtIndex:2];
        usMarket = caMarket = @"1";
    }else {
        [self.marketSegment setSelected:YES segmentAtIndex:1];
        usMarket = @"0";
        caMarket = @"1";
    }

    outOfStock = @"0";
    postLatter = @"0";
    
    // Initialize Out of Stock segment
    NSArray *outOfStockSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.outOfStockSegment = [self customizeSegmentControl:self.outOfStockSegment WithArray:outOfStockSegmentItems];
    
    NSArray *postOfStockSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.postLatterSegment = [self customizeSegmentControl:self.postLatterSegment WithArray:postOfStockSegmentItems];

    
    tirePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 150.0f)];
    [tirePicker setDataSource: self];
    [tirePicker setDelegate: self];
    tirePicker.showsSelectionIndicator = NO;
    tirePicker.translatesAutoresizingMaskIntoConstraints = NO;
    _txtTireCondition.inputView = tirePicker;

    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 216.0f)];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(setDateFrom:) forControlEvents:UIControlEventValueChanged];
    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    _txtDateOfAvailability.inputView = datePicker;

    
    [_txtDateOfAvailability setUserInteractionEnabled:NO];
    [self loadHistoryDetail];
    
    _scheduleLbl.hidden = true;
    _scheduleLineImage.hidden = true;
    _scheduleTimeTextField.hidden = true;
    

}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:YES];
//    UIView *header = self.tblHistory.tableFooterView;
//    
//    [header setNeedsLayout];
//    [header layoutIfNeeded];
//    
//    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    CGRect frame = header.frame;
//    
//    frame.size.height = height;
//    header.frame = frame;
//    
//    self.tblHistory.tableFooterView = header;
//}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
}


-(void)loadHistoryDetail {
    
    DisclosureVehicleHistory *vehicle_history = [VehicleDetails sharedInstance].disclosure_data.disclosure_vehicle_history;
    for (NSString *tempKey in arrHistory) {
      //  NSString *value = [vehicle_history protocolForArrayProperty:tempKey];
       // NSString *value = [vehicle_history [JSONModel classForCollectionProperty:tempKey]];
       // [historyData setValue:@"off" forKey:tempKey];
        if ([tempKey isEqualToString:@"Out of Province"]) {
            
        if([vehicle_history.out_of_province_vehicle isEqualToString:@"N"]) {
            
            [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:0]];
        }else {
            [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:0]];
        }
            
        }else if ([tempKey isEqualToString:@"Daily Rental"]) {
            
            if([vehicle_history.daily_rental isEqualToString:@"N"]) {
                
                [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:1]];
            }else {
                [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:1]];
            }
            
            
        }else if ([tempKey isEqualToString:@"Fire Damaged"]) {
            
            if([vehicle_history.fire_damaged isEqualToString:@"N"]) {
                
                [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:2]];
            }else {
                [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:2]];
            }
            
        }else if ([tempKey isEqualToString:@"Immeresd in Water"]) {
            
            if([vehicle_history.immersed_in_water isEqualToString:@"N"]) {
                
                [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:3]];
            }else {
                [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:3]];
            }
            
        }else if ([tempKey isEqualToString:@"Police Cruiser"]) {
            
            if([vehicle_history.police_cruiser isEqualToString:@"N"]) {
                
                [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:4]];
            }else {
                [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:4]];
            }
            
        }else if ([tempKey isEqualToString:@"Taxi or Limo"]) {
            
            if([vehicle_history.tax_or_limo isEqualToString:@"N"]) {
                
                [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:5]];
            }else {
                [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:5]];
            }
            
        }else if ([tempKey isEqualToString:@"Theft Recovery"]) {
            
            if([vehicle_history.theft_recovery isEqualToString:@"N"]) {
                
                [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:6]];
            }else {
                [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:6]];
            }
            
            
        }else if ([tempKey isEqualToString:@"Airbag Missing"]) {
            
            if([vehicle_history.airbag_missing_inoperable isEqualToString:@"N"]) {
                
                [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:7]];
            }else {
                [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:7]];
            }
            
            
        }else if ([tempKey isEqualToString:@"Total loss by Insurer"]) {
            
            if([vehicle_history.total_loss_by_insurer isEqualToString:@"N"]) {
                
                [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:8]];
            }else {
                [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:8]];
            }
            
        }
         [_tblHistory reloadData];
    }
   
    
    
      DisclosureVehicleCondition *conditionData = [VehicleDetails sharedInstance].disclosure_data.disclosure_vehicle_condition ;

    if([conditionData.engine_needs_repair isEqualToString:@"N"]) {
        [_engineRepairSegment setSelected:YES segmentAtIndex:1];
    }else {
        [_engineRepairSegment setSelected:YES segmentAtIndex:0];
    }
    
    
    switch ([conditionData.windshield_condition intValue]) {
        case 1:
            [_windshieldSegment setSelected:YES segmentAtIndex:0];
            break;
        case 2:
            [_windshieldSegment setSelected:YES segmentAtIndex:1];
            break;
        case 3:
            [_windshieldSegment setSelected:YES segmentAtIndex:2];
            break;
            
        default:
            [_windshieldSegment setSelected:YES segmentAtIndex:0];
            break;
    }
    
    switch ([conditionData.tire_condition intValue]) {
        case 1:
            [_txtTireCondition setText:@"Good"];
            break;
        case 2:
            [_txtTireCondition setText:@"Average"];
            break;
        case 3:
            [_txtTireCondition setText:@"Need 1 Tire"];
            break;
        case 4:
            [_txtTireCondition setText:@"Need 2 Tire"];
            break;
        case 5:
            [_txtTireCondition setText:@"Need 3 Tire"];
            break;
        case 6:
            [_txtTireCondition setText:@"Need 4 Tire"];
            break;
        default:
            [_txtTireCondition setText:@"Good"];
            break;
    }
    
    DisclosureVehicleDeclaration *disclosureData = [VehicleDetails sharedInstance].disclosure_data.disclosure_vehicle_declaration ;
    
    
    if([disclosureData.vehicle_lien isEqualToString:@"N"])
    {
        [_vehicleLienSegment setSelected:YES segmentAtIndex:1];
    }else {
        [_vehicleLienSegment setSelected:YES segmentAtIndex:0];
    }
    
    if([disclosureData.pending_vehicle isEqualToString:@"N"])
    {
        [_pendingVehicleSegment setSelected:YES segmentAtIndex:1];
    }else {
        [_pendingVehicleSegment setSelected:YES segmentAtIndex:0];
    }
    
    if([[VehicleDetails sharedInstance].asIs_vehicle isEqualToString:@"Y"])
    {
        [_asIsVehicleSegment setSelected:YES segmentAtIndex:0];
    }else {
        [_asIsVehicleSegment setSelected:YES segmentAtIndex:1];
    }
    
    _txtComment.text = [VehicleDetails sharedInstance].option_description;
    
    if(_txtComment.text.length == 0) {
        [_txtComment setText:@"Comments"];
    }
   
    switch ([disclosureData.accident_brand intValue]) {
        case 1:
            [_accidentSegment setSelected:YES segmentAtIndex:0];
            break;
        case 2:
            [_accidentSegment setSelected:YES segmentAtIndex:1];
            break;
        case 3:
            [_accidentSegment setSelected:YES segmentAtIndex:2];
            break;
        case 4:
            [_accidentSegment setSelected:YES segmentAtIndex:3];
            break;
        default:
            [_accidentSegment setSelected:YES segmentAtIndex:3];
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrHistory count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    [cell.lblTitle setText:[arrHistory objectAtIndex:indexPath.row]];
//    [cell.btnSwitch setOn:NO];
   // [cell.btnSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    //[cell.btnSwitch setTag:indexPath.row];
    
    [cell.yesNoSegment setTag:indexPath.row];
    [cell.yesNoSegment addTarget:self action:@selector(tableSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
    if (historyData.count > 0 ){
        NSString *value = [historyData objectForKey:[NSString stringWithFormat:@"%@",[arrHistoryKey objectAtIndex:indexPath.row]]];
        if([value isEqualToString:@"on"]) {
            [cell.yesNoSegment setSelected:YES segmentAtIndex:0];
        }else {
            [cell.yesNoSegment setSelected:YES segmentAtIndex:1];
        }
    
    }
  
    
 //   [cell.yesNoSegment setSelected:YES segmentAtIndex:1];
    return cell;
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == _txtDateOfAvailability) {
        [self setDateFrom:datePicker];
    }
    
    datePicker=[[UIDatePicker alloc]init];
     [datePicker setMinimumDate: [NSDate date]];
    datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    [self.scheduleTimeTextField setInputView:datePicker];
}

#pragma mark - Custom Methods

-(void)postToAuction {
    //720
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [WSLoading getUserDefaultValueFromKey:@"vehicle_id"],@"vehicle_id",
                                   [WSLoading getUserDefaultValueFromKey:@"car_type"],@"car_type",
                                   [WSLoading getUserDefaultValueFromKey:@"vin_id"],@"vin_id",
                                   engineRepairs,@"condition_data[engine_repair]",
                                   windShieldCondition,@"condition_data[winshield]",
                                   tireCondition,@"condition_data[tire]",
                                   vehicleLien,@"diclaration_data[vehicle_lien]",
                                   pendingVehicle,@"diclaration_data[pending_vehicle]",
                                   asISVEHICLE,@"diclaration_data[asIs_vehicle]",
                                   accidentBrand,@"diclaration_data[accident_brand]",
                                   @"120",@"setting_data[auction_end_time]",
                                   _txtComment.text,@"option_description",
                                   outOfStock,@"out_of_stock",
                                   usMarket,@"auction_for_us",
                                   caMarket,@"auction_for_ca",
                                   _txtReservePrice.text,@"reserve_price",
                                   dateString,@"date_shced",
                                   timeString,@"tm_shced",
                                   postType,@"post_type",
                                   nil];
    
    if([outOfStock isEqualToString:@"1"]) {
        [params setValue:_txtDateOfAvailability.text forKey:@"date_of_availability"];
    }
    
    [params addEntriesFromDictionary:historyData];
    
    //    NSDictionary *headers = [NSDictionary dictionaryWithObject:[WSLoading getCurrentUserDetailForKey:@"auth_key"] forKey:@"AUTH_KEY"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,SAVE_DISCLOSURE];
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSString *json = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        //        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
        //                                                             options:NSJSONReadingAllowFragments
        //                                                               error:&error];
        NSLog(@"JSON:%@",json);
        if(!error) {
            [VehicleDetails resetSharedInstance];
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isAuctionPosted"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"Your Vehicle has been posted on Auction successfully" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                [[self.tabBarController selectedViewController].navigationController popToRootViewControllerAnimated:YES];
                
                //if any controller is presented as a model view then
                //[[self.tabBarController selectedViewController] dismissModalViewControllerAnimated:YES];
                
                [self.tabBarController setSelectedIndex:2];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            
        }
        
    }];
}

-(void)setDateFrom:(UIDatePicker *)picker {
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [_txtDateOfAvailability setText:[dateFormat stringFromDate:picker.date]];
    
}
- (IBAction)tableSegmentValueChanged:(PPiFlatSegmentedControl *)sender {

    
    (sender.selectedSegmentIndex == 0) ?[historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:sender.tag]] : [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:sender.tag]];
    
}

-(void)switchChanged:(UISwitch *)sender {
    if(sender.on) {
        [historyData setValue:@"on" forKey:[arrHistoryKey objectAtIndex:sender.tag]];
    }else {
        [historyData setValue:@"off" forKey:[arrHistoryKey objectAtIndex:sender.tag]];
    }
}

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadDeclaration:(id)sender {
    [self btnPostToAucitonClicked:_btnPostToAuction];
}

-(PPiFlatSegmentedControl *)customizeSegmentControl:(PPiFlatSegmentedControl *)segmentControl WithArray:(NSArray *) array {
    [segmentControl setItems:array];
    segmentControl.borderWidth = 0.6;
    segmentControl.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    segmentControl.selectedColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    segmentControl.color = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    segmentControl.selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:12],
                                              NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]};
    
    segmentControl.textAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:12],
                                      NSForegroundColorAttributeName:[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0]};
    segmentControl.layer.cornerRadius = 5;
    segmentControl.clipsToBounds = YES;
//    [segmentControl setSegmentAtIndex:array.count-1 enabled:YES];
    [segmentControl setSelected:YES segmentAtIndex:array.count - 1];
    return segmentControl;
}

#pragma mark - UIButton Actions



- (IBAction)dateTimePickerAction:(id)sender {
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Date Picker"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"OK",nil];
    // Add the picker
    UIDatePicker *pickerView = [[UIDatePicker alloc] init];
    pickerView.datePickerMode = UIDatePickerModeDateAndTime;
    [menu addSubview:pickerView];
    [menu showInView:self.view];
    
    CGRect menuRect = menu.frame;
    CGFloat orgHeight = menuRect.size.height;
    menuRect.origin.y -= 214; //height of picker
    menuRect.size.height = orgHeight+214;
    menu.frame = menuRect;
    
    CGRect pickerRect = pickerView.frame;
    pickerRect.origin.y = orgHeight;
    pickerView.frame = pickerRect;
    
    
}



- (IBAction)btnDateClicked:(id)sender {
    if([outOfStock isEqualToString:@"1"]) {
        [_txtDateOfAvailability becomeFirstResponder];
    }
}

- (IBAction)btnTireClicked:(id)sender {
    [_txtTireCondition becomeFirstResponder];
}

- (IBAction)btnAgreeClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self checkForAuction];
}
- (IBAction)btnAgreeDisclosure:(UIButton *)sender {
     sender.selected = !sender.selected;
    [self checkForAuction];
}

-(void)checkForAuction {
   // if(_btnAgree.isSelected && _btnAgreeDisclosure.isSelected) {
    if( _btnAgreeDisclosure.isSelected) {
        [rightBarButton setEnabled:YES];
        [_btnParkVechile setHidden:NO];
        if ([postLatter isEqualToString:@"0"]) {
            
            [_btnPostToAuction setHidden:NO];
            [_btnScheduleVechile setHidden:YES];
            
          
            
        }else{
            [_btnScheduleVechile setHidden:NO];
            [_btnPostToAuction setHidden:YES];
            
            
        }
        
       
        
       
    }else {
        [rightBarButton setEnabled:NO];
        [_btnParkVechile setHidden:YES];
        [_btnPostToAuction setHidden:YES];
        [_btnScheduleVechile setHidden:YES];

    }
}


- (IBAction)btnScheduleVechileClicked:(id)sender {
    
    if (_scheduleTimeTextField.text && _scheduleTimeTextField.text.length > 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"Are you sure you want to post this vehicle to auction?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self postToAuction];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"The Schedule Time is required and cannot be empty."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


- (IBAction)btnParkVechileClicked:(id)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"Are you sure you want to park this vehicle to auction?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->postType = @"park";
        [self postToAuction];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)btnPostToAucitonClicked:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"Are you sure you want to post this vehicle to auction?" preferredStyle:UIAlertControllerStyleAlert];
   
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self postToAuction];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)segmentValueChanged:(PPiFlatSegmentedControl *)sender {
    switch (sender.tag) {
        case 101:
            // Engine Repair Segment
            engineRepairs = (sender.selectedSegmentIndex == 0) ? @"on" : @"off";
            break;
        case 102:
            // Windshield Condition Segment
            windShieldCondition = [NSString stringWithFormat:@"%lu",(unsigned long)sender.selectedSegmentIndex+1];
            break;
        case 103:
            // Accident Brand Segment
            accidentBrand = [NSString stringWithFormat:@"%lu",sender.selectedSegmentIndex + 1];
            break;
        case 104:
            // Vehicle Lien Segment
            vehicleLien = (sender.selectedSegmentIndex == 0) ? @"on" : @"off";
            break;
        case 105:
            // pending Vehicle  Segment
            pendingVehicle = (sender.selectedSegmentIndex == 0) ? @"on" : @"off";
            break;
        case 106:
        {
            // Market Segment
            if(sender.selectedSegmentIndex == 0) {
                usMarket = @"1";
                caMarket = @"0";
            }else if(sender.selectedSegmentIndex == 1) {
                usMarket = @"0";
                caMarket = @"1";
            }else {
                usMarket = @"1";
                caMarket = @"1";
            }
        }
            break;
        case 107:
            // Out of Stock Segment
            outOfStock = (sender.selectedSegmentIndex == 0) ? @"1" : @"0";
            CGFloat tempHeight = CGRectGetHeight(self.tblHistory.tableFooterView.frame);
            
            if([outOfStock isEqualToString:@"0"]) {
                
                [self.view layoutIfNeeded];
                
                dateViewHeightConstraint.constant = 0;
                [UIView animateWithDuration:.3 animations:^{
                     [self.view layoutIfNeeded];
                 }];
                
                [dateView setHidden:YES];
                
                [_txtDateOfAvailability setHighlighted:NO];
                [_txtDateOfAvailability setUserInteractionEnabled:NO];
                [_txtDateOfAvailability resignFirstResponder];
            }else {
                
                [self.view layoutIfNeeded];
                dateViewHeightConstraint.constant = 69;
                
                [UIView animateWithDuration:.3 animations:^{
                    [self.view layoutIfNeeded];
                    
                    UIView *header = self.tblHistory.tableFooterView;
                    
                    [header setNeedsLayout];
                    [header layoutIfNeeded];
                    
                    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                    CGRect frame = header.frame;
                    
                    frame.size.height = height + 40;
                    header.frame = frame;
                    
                    self.tblHistory.tableFooterView = header;
                    
                }];
                [dateView setHidden:NO];
                
                [_txtDateOfAvailability setHighlighted:YES];
//                [_txtDateOfAvailability setPlaceholder:@"Minimum value you want for your car"];
                [_txtDateOfAvailability setUserInteractionEnabled:YES];
                [_txtDateOfAvailability becomeFirstResponder];
            }
            break;
            case 108:
            postLatter = (sender.selectedSegmentIndex == 0) ? @"1" : @"0";
            if([postLatter isEqualToString:@"0"]) {
                
               _scheduleTimeTextField.hidden = true;
                _scheduleLbl.hidden = true;
                _scheduleLineImage.hidden = true;
                 [self checkForAuction];
                [self cancelDatePicker];
            }else{
                
              _scheduleTimeTextField.hidden = false;
                _scheduleLbl.hidden = false;
                _scheduleLineImage.hidden = false;
                [_scheduleTimeTextField becomeFirstResponder];
                 [self checkForAuction];
                
            }
             break;
        case 109:
            // pending Vehicle  Segment
            asISVEHICLE = (sender.selectedSegmentIndex == 0) ? @"on" : @"off";
            break;
        default:
            break;
    }
}


#pragma mark - UIPickerView Datasource

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [arrTire count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arrTire objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _txtTireCondition.text = [arrTire objectAtIndex:row];
    tireCondition = [NSString stringWithFormat:@"%ld",(long)row+1];
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
