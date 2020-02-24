//
//  ForgotPasswordViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 31/12/15.
//  Copyright © 2015 LB 3 Mac Mini. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AFNetworking.h"
#import "WSLoading.h"
#import "ForgotPassword.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Actions
- (IBAction)btnSubmitClicked:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"%@forgotPassword",BaseURL];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:_txtUsername.text forKey:@"username"];
    
    [WSLoading getResponseWithParameters:parameters Url:urlString Headers:nil CompletionBlock:^(id result) {
        ForgotPassword *objForgotPassword = [[ForgotPassword alloc]initWithData:result error:nil];
        if (objForgotPassword.success_message) {
            [WSLoading showAlertWithTitle:nil Message:objForgotPassword.success_message];
        }else {
            [WSLoading showAlertWithTitle:@"Error" Message:objForgotPassword.error_message];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnBackClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
