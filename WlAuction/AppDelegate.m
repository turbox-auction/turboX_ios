//
//  AppDelegate.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 30/12/15.
//  Copyright © 2015 LB 3 Mac Mini. All rights reserved.
//

#import "AppDelegate.h"
#import "MainNavigationViewController.h"
#import "MainTabViewController.h"
#import "WSLoading.h"
#import "Reachability.h"
#import "CRToast.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <UserNotifications/UserNotifications.h>
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define kColorGold [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

#define BUY_TAG 100
#define SELL_TAG 101
#define ADD_LIST_TAG 103
#define ADD_LIST_BASE_TAG 999

extern int myGlobal = 1;


@interface AppDelegate ()<PTPusherDelegate, UNUserNotificationCenterDelegate>
{
    
}
@end

@implementation AppDelegate
@synthesize footerTabView;
@synthesize rootController;
@synthesize mainNav;

+(NSString *)getBaseURL{
    if(myGlobal == 1) {
        return @"http://www.turbox.ca/";
    } else {
        return @"http://turboxusa.ca/";

    }

    
}

-(IBAction)homeBtnClicked:(id)sender {
    UIImageView *buyImgae = [footerTabView viewWithTag:BUY_TAG];
    UIImageView *sellImgae = [footerTabView viewWithTag:SELL_TAG];
    UIImageView *addListImgae = [footerTabView viewWithTag:ADD_LIST_TAG];
    
    buyImgae.image = [UIImage imageNamed:@"Buy_White"];
    sellImgae.image = [UIImage imageNamed:@"Sell_White"];
    addListImgae.image = [UIImage imageNamed:@"AddListing_black"];
    
    rootController.selectedIndex = 0;

}

-(IBAction)moreBtnClicked:(id)sender {
    UIImageView *buyImgae = [footerTabView viewWithTag:BUY_TAG];
    UIImageView *sellImgae = [footerTabView viewWithTag:SELL_TAG];
    UIImageView *addListImgae = [footerTabView viewWithTag:ADD_LIST_TAG];
    
    buyImgae.image = [UIImage imageNamed:@"Buy_White"];
    sellImgae.image = [UIImage imageNamed:@"Sell_White"];
    addListImgae.image = [UIImage imageNamed:@"AddListing_black"];
    
    
    rootController.selectedIndex = 4;


}

-(IBAction)buyBtnClicked:(id)sender {
    
    UIImageView *buyImgae = [footerTabView viewWithTag:BUY_TAG];
    UIImageView *sellImgae = [footerTabView viewWithTag:SELL_TAG];
    UIImageView *addListImgae = [footerTabView viewWithTag:ADD_LIST_TAG];

    buyImgae.image = [UIImage imageNamed:@"Buy"];
    sellImgae.image = [UIImage imageNamed:@"Sell_White"];
    addListImgae.image = [UIImage imageNamed:@"AddListing_black"];

    rootController.selectedIndex = 1;
    
}

-(IBAction)sellBtnClicked:(id)sender {
//    buyImgae.image = [UIImage imageNamed:@"Buy_White"];
//    sellImgae.image = [UIImage imageNamed:@"Sell_White"];

    UIImageView *buyImgae = [footerTabView viewWithTag:BUY_TAG];
    UIImageView *sellImgae = [footerTabView viewWithTag:SELL_TAG];
    UIImageView *addListImgae = [footerTabView viewWithTag:ADD_LIST_TAG];

    buyImgae.image = [UIImage imageNamed:@"Buy_White"];
    sellImgae.image = [UIImage imageNamed:@"Sell"];
    addListImgae.image = [UIImage imageNamed:@"AddListing_black"];

    rootController.selectedIndex = 3;

    
}

-(IBAction)addListingBtnClicked:(id)sender {
    UIImageView *buyImgae = [footerTabView viewWithTag:BUY_TAG];
    UIImageView *sellImgae = [footerTabView viewWithTag:SELL_TAG];
    UIImageView *addListImgae = [footerTabView viewWithTag:ADD_LIST_TAG];

        buyImgae.image = [UIImage imageNamed:@"Buy_White"];
        sellImgae.image = [UIImage imageNamed:@"Sell_White"];
    
    addListImgae.image = [UIImage imageNamed:@"AddListing"];


    
    rootController.selectedIndex = 2;
    
    
}
-(BOOL)hasTopNotch{
    if (@available(iOS 11.0, *)) {
        return [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.top > 20.0;
    }
    return  NO;
}
-(void)setUpFooterView {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    footerTabView = [[[NSBundle mainBundle] loadNibNamed:@"FooterView" owner:self options:nil] firstObject];
    UIView *baseView = [footerTabView viewWithTag:ADD_LIST_BASE_TAG];
    baseView.clipsToBounds = YES;
    baseView.layer.cornerRadius = (screenSize.width/6) - 10;//CGRectGetWidth(baseView.frame)/2;
    baseView.layer.borderWidth = 2;
    baseView.layer.borderColor = [UIColor blackColor].CGColor;

    
   // UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    //UIWindow* keyWindow = self.window;
    if ([self hasTopNotch]){
        footerTabView.frame = CGRectMake(0, screenSize.height - 109, screenSize.width, 74);
    } else {
        footerTabView.frame = CGRectMake(0, screenSize.height - 69, screenSize.width, 69);
    }
    
    [mainNav.view addSubview:footerTabView];
    self.rootController.tabBar.alpha = 0;


}

- (void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    myGlobal = 1;
    [Fabric with:@[[Crashlytics class]]];

    self.pusherClient = [PTPusher pusherWithKey:PUSHER_API_KEY delegate:self];
    
    [self.pusherClient connect];
    
    [self.pusherClient subscribeToChannelNamed:@"auction_wheelslot"];
//    [SharedAppDelegate pusherClient].authorizationURL
      [self iQKeboardManager];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header"] forBarMetrics:UIBarMetricsDefault];

    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kColorGold,NSFontAttributeName:[UIFont fontWithName:@"Lato" size:18.0]}];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[defaults dictionaryRepresentation].allKeys containsObject:@"currentUser"]) {
        // unarchive the value here
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
//    if(![defaults valueForKey:@"currentUser"]) {
//        NSLog(@"User does not Exists");
//         self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
//    }else {
    else {
        [WSLoading sendUserDeviceToken];
         mainNav = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"MainNavigationViewController"];
        
         rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainTabViewController"];
       
        [mainNav setViewControllers:@[rootController]animated:NO];
        self.window.rootViewController = mainNav;
       // [self.rootController.tabBar setHidden:YES];
        self.rootController.tabBar.alpha = 0;

       [self performSelector:@selector(setUpFooterView) withObject:nil afterDelay:1];
        ///[self setUpFooterView];
    }
    
    
    [self registerForRemoteNotifications];
    // Clear notification badge
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    [self needsUpdate:^(NSDictionary *dictionary) {
        // you can use the dictionary here
        
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        if ([dictionary[@"resultCount"] integerValue] == 1){
            NSString* appStoreVersion = dictionary[@"results"][0][@"version"];
            NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
            if (![appStoreVersion isEqualToString:currentVersion]){
                NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
                [self showAlert];
            }
            
            
        }
        
        // if you want to update UI or model, dispatch this to the main queue:
        // dispatch_async(dispatch_get_main_queue(), {
        // do your UI stuff here
        //    do nothing
        // });
    }];
    
    return YES;
}

-(void)needsUpdate:(void (^)(NSDictionary * dictionary))completionHandler{
    
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                      
                                      if (completionHandler) {
                                          completionHandler(lookup);
                                      }
                                      
                                      
                                      
                                  }];
    
    [task resume];
    
    
    
}

-(void)showAlert
{
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"please update app"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    @try
                                    {
                                        NSLog(@"tapped ok");
                                        BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
                                        if (canOpenSettings)
                                        {
                                            NSURL *url = [NSURL URLWithString:@"https://apps.apple.com/us/app/turbox/id1418579034?ls=1"];
                                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                                        }
                                    }
                                    @catch (NSException *exception)
                                    {
                                        
                                    }
                                }]];
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10
//Called when a notification is delivered to a foreground app.

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"User Info = %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}
//Called to let your app know which action was selected by the user for a given notification.

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
    completionHandler();
}



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // NS_AVAILABLE_IOS(8_0);
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    NSString *token = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(token.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DeviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if(deviceToken.length > 0) {
//        [self sendUserDeviceToken:token];
    }
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@ = %@", NSStringFromSelector(_cmd), error);
    NSLog(@"Error = %@",error);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"Notification:%@",userInfo);
    if(application.applicationState == UIApplicationStateActive) {
//        NSDictionary *options = @{
//                                  kCRToastTextKey : [[userInfo objectForKey:@"aps"] valueForKey:@"alert"],
//                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
//                                  kCRToastBackgroundColorKey : kColorGold,
//                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
//                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
//                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
//                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop)
//                                  };
//        [CRToastManager showNotificationWithOptions:options
//                                    completionBlock:^{
//                                        NSLog(@"Completed");
//                                    }];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)iQKeboardManager {
    
    //ONE LINE OF CODE.
    //Enabling keyboard manager(Use this line to enable managing distance between keyboard & textField/textView).
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    //(Optional)Set Distance between keyboard & textField, Default is 10.
    //[[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    
    //(Optional)Enable autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard. Default is NO.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //(Optional)Setting toolbar behaviour to IQAutoToolbarBySubviews to manage previous/next according to UITextField's hierarchy in it's SuperView. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order. Default is `IQAutoToolbarBySubviews`.
    //[[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //(Optional)Resign textField if touched outside of UITextField/UITextView. Default is NO.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //(Optional)Giving permission to modify TextView's frame. Default is NO.
    //    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    
    //(Optional)Show TextField placeholder texts on autoToolbar. Default is NO.
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
    
}

- (void)startReachabilityCheck
{
    
    Reachability *rechability = [Reachability reachabilityForInternetConnection];
    [rechability startNotifier];
    NetworkStatus netStatus = [rechability currentReachabilityStatus];
    if (netStatus != NotReachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pusherClient connect];
        });
    }
}

#pragma marks - Pusher Delegate Methods
- (BOOL)pusher:(PTPusher *)pusher connectionWillConnect:(PTPusherConnection *)connection
{
    NSLog(@"[pusher] Pusher client connecting...");
    return YES;
}

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
    NSLog(@"[pusher-%@] Pusher client connected", connection.socketID);
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
    NSLog(@"[pusher] Pusher Connection failed with error: %@", error);
    if ([error.domain isEqualToString:(NSString *)kCFErrorDomainCFNetwork]) {
        [self startReachabilityCheck];
    }
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error willAttemptReconnect:(BOOL)willAttemptReconnect
{
    NSLog(@"[pusher-%@] Pusher Connection disconnected with error: %@", pusher.connection.socketID, error);
    
    if (willAttemptReconnect) {
        NSLog(@"[pusher-%@] Client will attempt to reconnect automatically", pusher.connection.socketID);
    }
    else {
        if (![error.domain isEqualToString:PTPusherErrorDomain]) {
            [self startReachabilityCheck];
        }
    }
}

- (BOOL)pusher:(PTPusher *)pusher connectionWillAutomaticallyReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay
{
    NSLog(@"[pusher-%@] Client automatically reconnecting after %d seconds...", pusher.connection.socketID, (int)delay);
    return YES;
}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel
{
    NSLog(@"[pusher-%@] Subscribed to channel %@", pusher.connection.socketID, channel);
}

- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error
{
    NSLog(@"[pusher-%@] Authorization failed for channel %@", pusher.connection.socketID, channel);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Failed" message:[NSString stringWithFormat:@"Client with socket ID %@ could not be authorized to join channel %@", pusher.connection.socketID, channel.name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)pusher:(PTPusher *)pusher didReceiveErrorEvent:(PTPusherErrorEvent *)errorEvent
{
    NSLog(@"[pusher-%@] Received error event %@", pusher.connection.socketID, errorEvent);
}




@end
