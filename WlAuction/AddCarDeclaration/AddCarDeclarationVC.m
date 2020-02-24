//
//  AddCarDeclarationVC.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 06/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "AddCarDeclarationVC.h"
#import "PPiFlatSegmentedControl.h"

@interface AddCarDeclarationVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *tirePicker;
    NSMutableArray *arrTire;
}
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *engineRepairSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *windshieldSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *accidentSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *vehicleLienSegment;
@property (weak, nonatomic) IBOutlet UITextField *txtTireCondition;

@property (weak, nonatomic) IBOutlet UIButton *btnPostToAuction;
@end

@implementation AddCarDeclarationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBarController setTitle:@"SELL DETAILS"];
    arrTire = [NSMutableArray arrayWithObjects:@"Good",@"Average",@"Need 1 Tire",@"Need 2 Tire",@"Need 3 Tire",@"Need 4 Tire", nil];
    
    [_btnPostToAuction.layer setCornerRadius:5];
    [_btnPostToAuction setClipsToBounds:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    // Initialize engine repairs segment
    NSArray *engineRepairSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.engineRepairSegment = [self customizeSegmentControl:self.engineRepairSegment WithArray:engineRepairSegmentItems];
    
    // Initialize windshield condition segment
    NSArray *windshieldSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Normal" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Chipped" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Cracked" andIcon:nil], nil];
    self.windshieldSegment = [self customizeSegmentControl:self.windshieldSegment WithArray:windshieldSegmentItems];
    
    // Initialize accident brand segment
    NSArray *accidentSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Salvage" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Rebuilt" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"Irreparable" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"None" andIcon:nil], nil];
    self.accidentSegment = [self customizeSegmentControl:self.accidentSegment WithArray:accidentSegmentItems];
    
    // Initialize vehicle lien segment
    NSArray *vehicleLienSegmentItems = [NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Yes" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"No" andIcon:nil], nil];
    self.vehicleLienSegment = [self customizeSegmentControl:self.vehicleLienSegment WithArray:vehicleLienSegmentItems];
    
    tirePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 150)];
    [tirePicker setDataSource: self];
    [tirePicker setDelegate: self];
    tirePicker.showsSelectionIndicator = NO;
    _txtTireCondition.inputView = tirePicker;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(PPiFlatSegmentedControl *)customizeSegmentControl:(PPiFlatSegmentedControl *)segmentControl WithArray:(NSArray *) array {
    [segmentControl setItems:array];
    segmentControl.borderWidth = 0.6;
    segmentControl.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    segmentControl.selectedColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    segmentControl.color = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    segmentControl.selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:12],
                                              NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:198/255.0 blue:19/255.0 alpha:1.0]};
    
    segmentControl.textAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:12],
                                      NSForegroundColorAttributeName:[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0]};
    segmentControl.layer.cornerRadius = 5;
    segmentControl.clipsToBounds = YES;
    [segmentControl setSegmentAtIndex:0 enabled:YES];
    return segmentControl;
}

- (IBAction)btnTireClicked:(id)sender {
    [_txtTireCondition becomeFirstResponder];
}

- (IBAction)btnPostToAuctionClicked:(id)sender {
    
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
