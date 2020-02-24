//
//  LoginViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 31/12/15.
//  Copyright © 2015 LB 3 Mac Mini. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Validations.h"
#import "MainTabViewController.h"
#import "WSLoading.h"
#import "Login.h"
#import "SignupViewController.h"
#import "WebViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL isValidEmail, isValidPassword;
}
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgInvalidEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgInvalidPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnTurboxCA;
@property (weak, nonatomic) IBOutlet UIButton *btnTurboxUSA;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    


#pragma mark - UITextField Delegates
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == self.txtEmail) {
        if([[Validations sharedInstance] validationForLength:textField]) {
            [self.imgInvalidEmail setHidden:YES];
            isValidEmail = YES;
        }
        else {
            [self.imgInvalidEmail setHidden:NO];
            isValidEmail = NO;
        }
    }
    if(textField == self.txtPassword) {
        if([[Validations sharedInstance]validationForPassword:textField]) {
            [self.imgInvalidPassword setHidden:YES];
            isValidPassword = YES;
        }
        else
        {
            [self.imgInvalidPassword setHidden:NO];
            isValidPassword = NO;
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (IBAction)btnTurboxCAClicked:(id)sender {
    myGlobal = 1;
    _btnTurboxCA.backgroundColor = UIColor.redColor;
    [_btnTurboxCA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnTurboxUSA.backgroundColor = UIColor.whiteColor;
    [_btnTurboxUSA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
    
}



- (IBAction)btnTurboxUSAClicked:(id)sender {
    myGlobal = 0;

    _btnTurboxUSA.backgroundColor = UIColor.redColor;
    [_btnTurboxUSA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnTurboxCA.backgroundColor = UIColor.whiteColor;
    [_btnTurboxCA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
}






- (IBAction)btnLoginClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:_txtEmail.text,@"X-Wlasccpewl-Username",_txtPassword.text,@"X-Wlasccpewl-Password", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,LOGIN];
    
    NSLog(@"urlString %@",urlString);
    
    [WSLoading getResponseWithParameters:nil Url:urlString Headers:header CompletionBlock:^(id result) {
        NSError *error;
        Login *login = [[Login alloc]initWithData:result error:&error];
        if(!error && !login.error_message){
            [WSLoading saveCurrentUser:login];
            myappDelegate.mainNav = (MainNavigationViewController *)self.navigationController;
            myappDelegate.rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabViewController"];
            [myappDelegate setUpFooterView];
           
            [self.navigationController pushViewController:myappDelegate.rootController animated:YES];
         
        }else {
            [WSLoading showAlertWithTitle:@"Error" Message:login.error_message];
        }
    }];
    

}
- (IBAction)btnRegistrationForm:(id)sender {
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SIGINUP_WEB]];
   // WebViewController *SignupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
     SignupViewController *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];

    [self.navigationController pushViewController:signUpVC animated:YES];
    
    
}



@end
