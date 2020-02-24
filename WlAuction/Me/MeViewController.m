//
//  MeViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 08/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "MeViewController.h"
#import "UIButton+Position.h"
#import "MyInventoryViewController.h"
#import "ProfileViewController.h"
#import "InvoiceViewController.h"
#import "BuylostViewController.h"
#import "FeedbackViewController.h"
#import "TermsViewController.h"
#import "DocumentsViewController.h"
#import "AppDelegate.h"
#import "FavAuctionViewController.h"
#import "WSLoading.h"
#import "CarProofViewController.h"

@interface MeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnAuction;
@property (weak, nonatomic) IBOutlet UIButton *btnCars;
@property (weak, nonatomic) IBOutlet UIButton *btnInvoices;

@property (weak, nonatomic) IBOutlet UIButton *btnInventory;
@property (weak, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tabBarController setTitle:@"ME"];
//    if( [[NSUserDefaults standardUserDefaults]boolForKey:@"isAuctionPosted"]) {
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isAuctionPosted"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        [self.tabBarController setSelectedIndex:2];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Events
- (IBAction)btnInventoryClicked:(id)sender {
    MyInventoryViewController *myInventory = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInventoryViewController"];
    [self.navigationController pushViewController:myInventory animated:YES];
}

- (IBAction)btnProfileClicked:(id)sender {
    ProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:profileView animated:YES];
}

- (IBAction)btnInvoiceClicked:(id)sender {
    InvoiceViewController *invoiceView = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoiceViewController"];
    [self.navigationController pushViewController:invoiceView animated:YES];
}

- (IBAction)btnFavAucitonClicked:(id)sender {
    FavAuctionViewController *favAuction = [self.storyboard instantiateViewControllerWithIdentifier:@"FavAuctionViewController"];
    [self.navigationController pushViewController:favAuction animated:YES];
}

- (IBAction)btnLogoutClicked:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Out" message:@"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [Login resetSharedInstance];
        [VehicleDetails resetSharedInstance];
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];

    [self presentViewController:alert animated:YES completion:nil];
    
//    [self.tabBarController.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnTermsClicked:(id)sender {
//    TermsViewController *termsView = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
//    [self.navigationController pushViewController:termsView animated:YES];
    CarProofViewController *terms = [self.storyboard instantiateViewControllerWithIdentifier:@"CarProofViewController"];
    terms.mainTitle = @"Terms & Condition";
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    terms.urlString = [[NSBundle mainBundle] pathForResource:@"terms"
                                                      ofType:@"html"];
    [self.navigationController pushViewController:terms animated:YES];
}

- (IBAction)btnFeedbackClicked:(id)sender {
    FeedbackViewController *feedbackView = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self.navigationController pushViewController:feedbackView animated:YES];
}

- (IBAction)btnDocumentsClicked:(id)sender {
    DocumentsViewController *documentsView = [self.storyboard instantiateViewControllerWithIdentifier:@"DocumentsViewController"];
    [self.navigationController pushViewController:documentsView animated:YES];
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
