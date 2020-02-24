//
//  WebViewController.m
//  WlAuction
//
//  Created by Rajesh on 25/06/18.
//  Copyright © 2018 LB 3 Mac Mini. All rights reserved.
//

#import "WebViewController.h"
#import "WebSerManager.h"


@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:SIGINUP_WEB];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:requestObj];
}

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
