//
//  FeedbackViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "FeedbackViewController.h"
#import "WSLoading.h"

@interface FeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    NSMutableAttributedString *title,*comment;
}
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@property (weak, nonatomic) IBOutlet UITextView *txtComment;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    title = [[NSMutableAttributedString alloc]initWithString:@"Title*"];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(title.length-1, 1)];
    [_txtTitle setAttributedText:title];
    
    comment = [[NSMutableAttributedString alloc]initWithString:@"Comment*"];
    [comment addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(comment.length-1, 1)];
    [comment addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Lato" size:16.0] range:NSMakeRange(0, comment.length)];
    [_txtComment setAttributedText:comment];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.tabBarController setTitle:@"FEEDBACK"];
    
    
    // Add bar button items
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
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

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Comment*"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [textView setAttributedText:comment];
    }
    [textView resignFirstResponder];
}

#pragma mark - UITextField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if([textField.text isEqualToString:@""]) {
        [textField setAttributedText:title];
    }
    [textField resignFirstResponder];
}

#pragma mark - UIButton Actions
- (IBAction)btnResetClicked:(id)sender {
    [_txtTitle setAttributedText:title];
    [_txtComment setAttributedText:comment];
}


- (IBAction)btnSubmitClicked:(id)sender {
    [self.view endEditing:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _txtTitle.text,@"feedback_title",
                            _txtComment.text,@"feedback_content",
                            @"Feedback",@"Feedback",
                            [[Login sharedInstance] dealer_email],@"dealer_email",
                            [[Login sharedInstance] display_name],@"display_name",
                            @"",@"mob",
                            nil];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,FEEDBACK];
    
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSString *json = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
                NSLog(@"JSON:%@",json);
        if(!error) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Feedback" message:@"Your feedback has been added successfully!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

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
