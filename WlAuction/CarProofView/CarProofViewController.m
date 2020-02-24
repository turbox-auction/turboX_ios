//
//  CarProofViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 18/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "CarProofViewController.h"
#import "WSLoading.h"

@interface CarProofViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *carProofWebView;

@end

@implementation CarProofViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _carProofWebView.delegate = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [_carProofWebView loadRequest:urlRequest];
    _carProofWebView.scalesPageToFit = YES;
//    [_carProofWebView load]
    [self.tabBarController setTitle:_mainTitle];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
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

#pragma mark - WebView Delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [WSLoading showLoading];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [WSLoading dismissLoading];
}

#pragma mark - Custom Methods

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
