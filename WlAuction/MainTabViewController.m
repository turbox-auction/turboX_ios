//
//  MainTabViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 01/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "MainTabViewController.h"
#import "WSLoading.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
//    self.title = @"Dashboard";
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
   // [[UITabBar appearance] setTintColor:[UIColor colorWithRed:230/255.0 green:0/255.0 blue:29/255.0 alpha:1.0]];
    
    [[UITabBar appearance]setBarTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]
                                                        } forState:UIControlStateSelected];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateNormal];
    
     
    
  //  [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
   // [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [self setSelectedIndex:1];
 
   
   
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if([item.title isEqualToString:@"PROFILE"]) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
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
