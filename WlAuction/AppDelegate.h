//
//  AppDelegate.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 30/12/15.
//  Copyright © 2015 LB 3 Mac Mini. All rights reserved.
//

#define myappDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

extern int myGlobal;

#import <UIKit/UIKit.h>
#import "Pusher.h"
#import "DetailViewController.h"
#import "FooterTabView.h"
#import "MainTabViewController.h"
#import "MainNavigationViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PTPusher *pusherClient;

@property (strong, nonatomic) MainTabViewController *rootController;
@property (strong, nonatomic)MainNavigationViewController *mainNav;
@property (strong, nonatomic)  UIView *footerTabView;

-(IBAction)homeBtnClicked:(id)sender;
-(IBAction)moreBtnClicked:(id)sender;
-(void)setUpFooterView;
+(NSString *)getBaseURL;
@end

