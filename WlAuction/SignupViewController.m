//
//  SignupViewController.m
//  WlAuction
//
//  Created by Rajesh on 21/06/18.
//  Copyright © 2018 LB 3 Mac Mini. All rights reserved.
//

#import "SignupViewController.h"
#import "WSLoading.h"
#import "Validations.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;
@property (weak, nonatomic) IBOutlet UITextField *postalTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *faxTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *websiteTextField;
@property (weak, nonatomic) IBOutlet UITextField *dealerOMVICNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *hstNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *rinNumberTextField;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCheckClicked:(id)sender {
    UIButton *checkTag = (UIButton *)sender;
    if (checkTag.tag == 0) {
        [checkTag setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [checkTag setTag:1];
    } else {
        [checkTag setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [checkTag setTag:0];

    }
}

- (IBAction)btnSignUpClicked:(id)sender {
    
    NSUInteger checkTag = _checkBtn.tag;
    [self.view endEditing:YES];
    
     //if(![[Validations sharedInstance] validationForLength:_nameTextField]) {
    if (_nameTextField.text.length < 1 ) {
        [self showAlertWithMessage:@"The Name is required and cannot be empty."];
    }  else  if(_phoneTextField.text.length < 10 ) {
        [self showAlertWithMessage:@"Phone number must have at least 10 digits."];

    }else if(![[Validations sharedInstance] validateEmail:_emailTextField.text]) {
        [self showAlertWithMessage:@"Please enter a vaild email."];
        
    } else if (checkTag == 0 ) {
        
        [self showAlertWithMessage:@"Please select terms of use."];

    }
   //  else if([[Validations sharedInstance]validationForPassword:textField]) {
  //        [self.imgInvalidPassword setHidden:YES];
 //        isValidPassword = YES;
//    }
    else {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_nameTextField.text,@"dealershipName",_addressTextField.text,@"dealershipAddress", _cityTextField.text,@"city",   _provinceTextField.text,@"province",    _postalTextField.text,@"postalCode",   _phoneTextField.text,@"phone",    _faxTextField.text,@"fax",   _emailTextField.text,@"email",_websiteTextField.text,@"website",_dealerOMVICNoTextField.text,@"dealer_no",_hstNumberTextField.text,@"hst_no",_rinNumberTextField.text,@"rin_no",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",SIGNUP_URL];
    /*
     1.dealershipName
     2.dealershipAddress
     3.city
     4.province
     5.postalCode
     6.email
     7.phone
     8.fax
     9.website
     */
    
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSString *convertedString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        NSString *success = [json objectForKey:@"success"];
        BOOL error = [json objectForKey:@"error"];
        
        if (success != nil) {
            if ([success isEqualToString:@"success"]) {
                [self showAlertWithMessage:[json objectForKey:@"msg"]];
                [self performSelector:@selector(backBtnClick:) withObject:nil afterDelay:.5];
            } else {
                [self showAlertWithMessage:@"Unable to SignUp."];

            }
        }else  if (error == true){
            
             [self showAlertWithMessage:[json objectForKey:@"message"]];
            
        } else {
            [self showAlertWithMessage:@"Unable to SignUp."];

        }
        NSLog(@"%@",convertedString);
    }];
    
    }
}

-(void)showAlertWithMessage:(NSString *)message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
