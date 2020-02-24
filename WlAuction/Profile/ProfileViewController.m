//
//  ProfileViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "ProfileViewController.h"
#import "WSLoading.h"
#import "Login.h"

@interface ProfileViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress1;

@property (weak, nonatomic) IBOutlet UITextField *txtPhone;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtOmvic;

@property (weak, nonatomic) IBOutlet UITextField *txtRin;

@property (weak, nonatomic) IBOutlet UITextField *txtHst;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self setProfileData];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.tabBarController setTitle:@"PROFILE SETTINGS"];
    
    UIColor *placeholderColor = [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1.0];
    //    txtYear.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtYear.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    for (UIView *tempView in _mainView.subviews) {
        if([tempView isKindOfClass:[UITextField class]]) {
            [self setTextField:(UITextField *)tempView PlaceholderWithColor:placeholderColor];
        }
    }
    
    // Add bar button items
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editClicked:)];
    
//        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"true_icon"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButton;
    
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

-(void)setProfileData {
    [_txtName setText:[WSLoading getCurrentUserDetailForKey:@"display_name"]];
    [_txtEmail setText:[WSLoading getCurrentUserDetailForKey:@"dealer_email"]];
    [_txtAddress1 setText:[WSLoading getCurrentUserDetailForKey:@"dealer_address"]];
    [_txtPhone setText:[WSLoading getCurrentUserDetailForKey:@"dealer_primary_phone"]];
    [_txtOmvic setText:[WSLoading getCurrentUserDetailForKey:@"omvic_number"]];
    [_txtRin setText:[WSLoading getCurrentUserDetailForKey:@"rin_number"]];
    [_txtHst setText:[WSLoading getCurrentUserDetailForKey:@"hst_number"]];
}

-(void)editClicked:(id)sender {
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"true_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButton;
    
    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:212/255.0 blue:7/255.0 alpha:1.0]];
    
    for (UIView *temp in _mainView.subviews) {
        if([temp isKindOfClass:[UITextField class]]) {
            [temp setUserInteractionEnabled:YES];
        }
    }
    [_txtName becomeFirstResponder];
}

-(void)doneClicked:(id)sender {
    
    [self resignFirstResponder];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,SAVE_PROFILE];

    NSDictionary *params = @{@"dealership_name":CheckNilString(_txtName.text),
                             @"dealer_address":CheckNilString(_txtAddress1.text),
                             @"dealer_primary_phone":CheckNilString(_txtPhone.text),
                             @"dealer_email":CheckNilString(_txtEmail.text),
                             @"omvic_number":CheckNilString(_txtOmvic.text),
                             @"rin_number":CheckNilString(_txtRin.text),
                             @"hst_number":CheckNilString(_txtHst.text)};
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];

        NSLog(@"save profile JSON:%@",json);
        if([json objectForKey:@"success"]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *encodedObject = [defaults objectForKey:@"currentUser"];
            Login *objLogin = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
            objLogin.display_name = _txtName.text;
            objLogin.dealer_email = _txtEmail.text;
            objLogin.dealer_address = _txtAddress1.text;
            
            [WSLoading saveCurrentUser:objLogin];
            
            UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editClicked:)];
            
            self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButton;
            
            [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:212/255.0 blue:7/255.0 alpha:1.0]];
            for (UIView *temp in _mainView.subviews) {
                if([temp isKindOfClass:[UITextField class]]) {
                    [temp setUserInteractionEnabled:NO];
                }
            }

        }else {
            [WSLoading dismissLoading];
            [WSLoading showAlertWithTitle:@"Error" Message:[json objectForKey:@"error_message"]];
        }
        if(!error) {
            UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editClicked:)];
            
            self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButton;
            
            [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:212/255.0 blue:7/255.0 alpha:1.0]];
            for (UIView *temp in _mainView.subviews) {
                if([temp isKindOfClass:[UITextField class]]) {
                    [temp setUserInteractionEnabled:NO];
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        }
    }];

    

}

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTextField:(UITextField *)textField PlaceholderWithColor:(UIColor *)color {
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];    
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
