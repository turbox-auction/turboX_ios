//
//  AddCarViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 04/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "AddCarViewController.h"
#import "PPiFlatSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import "AddCarDetailViewController.h"
#import "WSLoading.h"
#import "VinDetail.h"
#import "VinScanViewController.h"


@interface AddCarViewController ()<VinScanDelegate>
{
    NSString *carType;
    BOOL isVin;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segOldNew;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UITextField *txtVinNumber;

@end

@implementation AddCarViewController



-(void)moreBtnClicked:(id)sender {
    [myappDelegate moreBtnClicked:nil];
}

-(void)homeBtnClicked:(id)sender {
    [myappDelegate homeBtnClicked:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    carType = @"used";
    [VehicleDetails resetSharedInstance];
    isVin = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if(!isVin) {
        _txtVinNumber.text = @"";
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tabBarController setTitle:@"VIN SCAN"];
    [[self.btnPhoto layer] setBorderWidth:1.0f];
    [[self.btnPhoto layer] setBorderColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0].CGColor];
    _btnPhoto.layer.cornerRadius = 5.0f;
//    _btnPhoto.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1.0]);

    
    _btnPhoto.clipsToBounds = YES;
    
    [_segmentedControl setItems:[NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Used Car" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"New Car" andIcon:nil], nil]];
    _segmentedControl.selectedColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    _segmentedControl.color = [UIColor whiteColor];
    _segmentedControl.selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14],
                                                 NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]};
    
    _segmentedControl.textAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14],
                                                 NSForegroundColorAttributeName:[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0]};
    _segmentedControl.layer.cornerRadius = 5;
    _segmentedControl.clipsToBounds = YES;
    [_segmentedControl setSegmentAtIndex:0 enabled:YES];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"true_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(getVinDetails:)];
    
    
    UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More_White"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBarButton,rightBarButton,nil];
    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    
    UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Home_White"] style:UIBarButtonItemStylePlain target:self action:@selector(homeBtnClicked:)];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = homeBarButton;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    isVin = NO;
}

#pragma mark - Segment Event

- (IBAction)segmentValueChanged:(PPiFlatSegmentedControl *)sender {
    NSLog(@"Selected Index:%lu",(unsigned long)sender.selectedSegmentIndex);
    if(sender.selectedSegmentIndex == 0) {
        carType = @"used";
    }else {
        carType = @"new";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Method
-(void)getVinDetails:(id)sender {
//    [self ];
    if(_txtVinNumber.text.length != 0) {
        NSDictionary *params = @{@"vin":_txtVinNumber.text,
                                 @"cartType":carType};
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,VINDETAIL];
        NSDictionary *headers = [NSDictionary dictionaryWithObject:[WSLoading getCurrentUserDetailForKey:@"auth_key"] forKey:@"AUTH-KEY"];
        
        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        [request setValue:[Login sharedInstance].auth_key forHTTPHeaderField:@"AUTH_KEY"];
//        [request setHTTPBody:[self httpBodyForParamsDictionary:params]];
//        
//        [WSLoading callWebService:request resultBlock:^(BOOL isSuccess, NSString *message, NSString *strResponse) {
//            
//        }];
        
        [WSLoading getResponseWithParameters:params Url:urlString Headers:headers CompletionBlock:^(id result) {
            NSError *error;
            VinDetail *vinDetail = [[VinDetail alloc]initWithData:result error:&error];
            if(!error) {
                if(vinDetail.error_message) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:vinDetail.error_message preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }else {
                    setObjectInUserDefaults(@"vin_id", vinDetail.vin);
                    AddCarDetailViewController *addCarDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarDetailViewController"];
                    addCarDetails.vinDetail = vinDetail;
                    [self.navigationController pushViewController:addCarDetails animated:YES];
                }
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }else {
        [WSLoading showAlertWithTitle:nil Message:@"Please enter VIN number"];
    }
}


- (IBAction)btnVinScanClicked:(UIButton *)sender {
    [VehicleDetails resetSharedInstance];
    VinScanViewController *vinScan = [self.storyboard  instantiateViewControllerWithIdentifier:@"VinScanViewController"];
    vinScan.delegate = self;
    [self presentViewController:vinScan animated:YES completion:nil];
}

#pragma mark - VinScan Delegate
-(void)vinScanViewControllerDismissed:(NSString *)vinString {
    if(vinString.length>17 && [vinString hasPrefix:@"I"]) {
        vinString = [vinString substringFromIndex:1];
    }
    isVin = YES;
    [_txtVinNumber setText:vinString];
}


- (NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
{
    NSMutableArray *parameterArray = [NSMutableArray array];
    
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}


- (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
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
