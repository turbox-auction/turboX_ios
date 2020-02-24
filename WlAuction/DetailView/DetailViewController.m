//
//  DetailViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 12/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "DetailViewController.h"
#import "CustomSectionHeaderCell.h"
#import "AddCarDetailViewController.h"
#import "AddCarHistoryViewController.h"
#import "CustomSectionHeaderCell.h"
#import "DisclosureCell.h"
#import "SummaryCell.h"
#import "BidHistoryViewController.h"
#import "IDMPhotoBrowser.h"
#import "CarPhoto.h"
#import "CarProofViewController.h"
#import "WSLoading.h"
#import "VehicleDetails.h"
#import "UIImageView+AFNetworking.h"
#import "FeaturesCell.h"
#import "AllBids.h"
#import "DisclosureData.h"
#import "UIImage+Resize.h"
#import <Pusher/Pusher.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,PTPusherDelegate>
{
    __weak IBOutlet UILabel *lblQuickBid;
    __weak IBOutlet UILabel *lblAuctionDeleted;
    __weak IBOutlet UILabel *lblAutoBid;
    __weak IBOutlet UIView *bidButtonView;
    VehicleDetails *vehicleDetails;
    NSMutableArray *arrCollapsed,*arrVehicleImages;
    NSArray *arrHeaderTitle;
    NSMutableSet *collapsedSection;
    NSString *pastBid;
    __weak IBOutlet UIView *tableViewHeader;

    
    __weak IBOutlet UIView *hidBidView;
    __weak IBOutlet UILabel *lblVehicleName;
    
    __weak IBOutlet UILabel *lblDealerName;
    
    __weak IBOutlet UILabel *lblDistance;

    __weak IBOutlet UILabel *lblDealerLocation;
    
    __weak IBOutlet UIImageView *imgFlag;
    __weak IBOutlet UILabel *lblInteriorColor;
    __weak IBOutlet UILabel *lblExteriorColor;
    __weak IBOutlet UILabel *lblMileage;
    __weak IBOutlet UIImageView *imgFav;
    
    __weak IBOutlet UIImageView *asIsVehicleImg;
    
    __weak IBOutlet UILabel *lblVin;
    
    __weak IBOutlet UILabel *lblCurrentBid;
    UIBlurEffect *blurEffect;
    UIVisualEffectView *blurEffectView;
    int numberOfSections;
    __weak IBOutlet UILabel *lblNumberOfBids;
    __weak IBOutlet UILabel *lblCountDown;
    ;
    NSTimer *timer;
    __weak IBOutlet UILabel *lblTrasnmissionShort;
    __weak IBOutlet UILabel *lblComment;
    __weak IBOutlet UIButton *btnCarProof;
    __weak IBOutlet UIButton *btnDelete;
     NSTimeInterval timeInterval;
    __weak IBOutlet UILabel *lblWarning;
    __weak IBOutlet UILabel *lblDamagedImages;
    AVAudioPlayer *avSound;
}

@property (weak, nonatomic) IBOutlet UITableView *tblDetails;

@property (weak, nonatomic) IBOutlet UIView *blurView;

@property (weak, nonatomic) IBOutlet UIScrollView *damageScrollView;

@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;
@property (weak, nonatomic) IBOutlet UIImageView *imgHistory;
@property (weak, nonatomic) IBOutlet UILabel *lblHistory;
//@property (weak, nonatomic) IBOutlet UIImageView *imgFav;
@property (weak, nonatomic) IBOutlet UILabel *lblFav;

@property (strong, nonatomic) PTPusher *currentClient;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_tblDetails addSubview:refreshControl];
    
    arrHeaderTitle = [NSArray arrayWithObjects:@"SUMMARY",@"ADDITIONAL OPTIONS",@"STANDARD OPTIONS",@"DISCLOSURE", nil];
    arrCollapsed = [NSMutableArray array];
    collapsedSection = [NSMutableSet set];
    [collapsedSection addObject:@(0)];
    [collapsedSection addObject:@(1)];
    [collapsedSection addObject:@(2)];
    [collapsedSection addObject:@(3)];

    
    _tblDetails.rowHeight = UITableViewAutomaticDimension;
    _tblDetails.estimatedRowHeight = 100;
    
    [_scrollCarImages.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_damageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        self.blurView.backgroundColor = [UIColor clearColor];
//        
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        blurEffectView.frame = self.blurView.frame;
//
//        [self.blurView addSubview:blurEffectView];
//        [self.blurView sendSubviewToBack:blurEffectView];
//    }
//    _damageScrollView.layer.borderWidth = 5.0;
//    _damageScrollView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:7/255.0 alpha:1.0].CGColor;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(carImageTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [tapGesture setNumberOfTapsRequired:1];
    [_scrollCarImages addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGestureDamagedCar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(carImageTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [tapGesture setNumberOfTapsRequired:1];
    
    [_damageScrollView addGestureRecognizer:tapGestureDamagedCar];
    
    if(_currentAuction != nil) {
        [lblNumberOfBids setText:_currentAuction.bid_received];

        [self getVehicleDetails];
    }
    
    timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateCountDown:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
 
    
    [[SharedAppDelegate pusherClient] bindToEventNamed:@"buy_detail_event" handleWithBlock:^(PTPusherEvent *channelEvent) {
        // channelEvent.data is a NSDictianary of the JSON object received
        
        NSDictionary *eventData = [[NSDictionary alloc]initWithDictionary:channelEvent.data];
        NSLog(@"EventData DetailView:%@",eventData);
        if ([_currentAuction.auction_id isEqualToString:[eventData objectForKey:@"auction_id"]]) {
            // This key success is true when auction is deleted
            if([eventData objectForKey:@"success"]) {
                NSLog(@"Auction has been deleted");
                [timer invalidate];
                
                [hidBidView setHidden:NO];
                if(![vehicleDetails.seller_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"This auction has been deleted by %@.",[eventData objectForKey:@"deleted_by"]] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }else {
                
                [lblAuctionDeleted setHidden:YES];
                NSString *bidAmount = [NSString stringWithFormat:@"%.0f",[[eventData objectForKey:@"bid_amount"] floatValue]];
                NSString *lastBidder = [eventData objectForKey:@"last_bidder_id"];
                
              
                if([vehicleDetails.current_bid_amount isEqualToString:bidAmount] || [lastBidder isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
                    [lblNumberOfBids setBackgroundColor:[UIColor colorWithRed:64/255.0 green:128/255.0 blue:0 alpha:1.0]];
                    [hidBidView setHidden:NO];
                }else {
                    [lblNumberOfBids setBackgroundColor:[UIColor redColor]];
                    [hidBidView setHidden:YES];
                }
                
                NSString *floatAsString = [NSString stringWithFormat:@" %@",[eventData valueForKey:@"bid_amount"]];
                NSArray *stringDivisions = [floatAsString componentsSeparatedByString:@"."];
                
                [lblCurrentBid setText:[NSString stringWithFormat:@"$ %@",stringDivisions[0]]];

                vehicleDetails.current_bid_amount = [eventData valueForKey:@"bid_amount"];
                [lblNumberOfBids setText:[eventData valueForKey:@"bid_count"]];
            }
        }

    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getVehicleDetails)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tabBarController setTitle:@"VEHICLE DETAILS"];
    
//      blurEffectView.frame = self.blurView.frame;
    
    // Add bar button items
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
       
    blurEffectView.frame = self.blurView.frame;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [VehicleDetails resetSharedInstance];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification
     object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)btnSummaryClicked:(id)sender {
//    AddCarDetailViewController *carSummary = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarDetailViewController"];
//    carSummary.isFromDetails = YES;
//    [self.navigationController pushViewController:carSummary animated:YES];
//}
//
//- (IBAction)btnDisclosureClicked:(id)sender {
//    AddCarHistoryViewController *carHistory = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarHistoryViewController"];
//    carHistory.isFromDetails = YES;
//    [self.navigationController pushViewController:carHistory animated:YES];
//}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == _scrollCarImages) {
        CGFloat pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        self.pageControl.currentPage = lround(pageIndex);
    }
}

#pragma mark - UIButton Events

- (IBAction)btnVinCopyClicked:(id)sender {

    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [lblVin.text stringByReplacingOccurrencesOfString:@"Vin: " withString:@""];
    
   // printf(pasteboard.string);
    [WSLoading showAlertWithTitle:@"" Message:@"Vin copied in clipboard"];

}

- (IBAction)btnDeleteClicked:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Auction" message:@"Are you sure you want to delete this auction?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,DELETEAUCTION];
        
        NSDictionary *params = @{@"auction_id":_currentAuction.auction_id};
        
        [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
            [WSLoading dismissLoading];
            NSError* error;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
            
            NSLog(@"JSON:%@",json);
            if(!error) {
                [hidBidView setHidden:NO];
                [timer invalidate];
                UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"Auction marked as deleted" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:successAlert animated:YES completion:nil];
            }else {
                [WSLoading dismissLoading];
                NSString *message = [json objectForKey:@"error_message"];
                if ([message length]) {
                    UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
                [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                    [self presentViewController:successAlert animated:YES completion:nil];

                }

            }
        }];

        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnHistoryClicked:(id)sender {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _currentAuction.car_type,@"car_type",
                            _currentAuction.auction_id,@"auction_id",
                            _currentAuction.dealer_country,@"dealer_country",
                            [WSLoading getCurrentUserDetailForKey:@"user_type"],@"user_type",
                            nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,BID_HISTORY];
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError *error;
        AllBids *allBids = [[AllBids alloc]initWithData:result error:&error];
        if(!error) {
            BidHistoryViewController *bidHistoryView = [self.storyboard instantiateViewControllerWithIdentifier:@"BidHistoryViewController"];
            bidHistoryView.allBids = allBids;
//            bidHistoryView.vehicleName = [NSString stringWithFormat:@"%@ %@ %@",_currentAuction.vehicle_year,_currentAuction.vehicle_make,_currentAuction.vehicle_model];
            bidHistoryView.vinNumber = allBids.vehicle_vin;
            bidHistoryView.vehicleName = allBids.vehicle_name;
            [self.navigationController pushViewController:bidHistoryView animated:YES];
        }else {
            
        }
    }];
    
    
}

- (IBAction)btnFavorite:(UIButton *)sender {
    sender.selected = !sender.selected;
//    [imgFav setHighlighted:sender.isSelected];
    
   
    
    NSDictionary *params = @{@"auction_id":_currentAuction.auction_id};
    NSString *urlString;
    if(sender.isSelected) {
        [_btnFavorite setImage:[UIImage imageNamed:@"favoriteSelected"] forState:UIControlStateNormal];
        urlString = [NSString stringWithFormat:@"%@%@",BaseURL,ADDFAVORITE];
    }else {
        urlString = [NSString stringWithFormat:@"%@%@",BaseURL,REMOVEFAVORITE];
        [_btnFavorite setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];

    }
   
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSString *json = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"JSON:%@",json);
        if(!error) {
            [_btnFavorite setHighlighted:sender.isSelected];
        }
    }];
    
}

- (IBAction)quickBidClicked:(id)sender {
    pastBid = vehicleDetails.current_bid_amount;

    [self createBidWithBidAmount:[NSString stringWithFormat:@"%d",[vehicleDetails.current_bid_amount intValue] + vehicleDetails.quickBidAmt]];
    
}

- (IBAction)placeBidClicked:(id)sender {
    pastBid = vehicleDetails.current_bid_amount;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter your bid amount" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Bid Amount";
         textField.keyboardType = UIKeyboardTypeNumberPad;
     }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([alertController.textFields[0].text intValue] >= [vehicleDetails.current_bid_amount intValue] + 149 ){
            NSLog(@"Bid Amount: %@",alertController.textFields[0].text);
            NSString *bidAmount = [NSString stringWithFormat:@"%d",[alertController.textFields[0].text intValue]];
            [self createBidWithBidAmount:bidAmount];
        }else {
            [WSLoading showAlertWithTitle:@"Alert" Message:[NSString stringWithFormat:@"Minimum bid amount value must be more than %d",[vehicleDetails.current_bid_amount intValue] + 149]];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)autoBidClicked:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Auto Bid" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
//     {
//         textField.placeholder = @"Current Bid";
//         textField.keyboardType = UIKeyboardTypeNumberPad;
//     }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Max Bid";
         textField.keyboardType = UIKeyboardTypeNumberPad;
     }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        NSLog(@"Current Bid:%@",alertController.textFields.firstObject.text);
        NSLog(@"Max Bid:%@",alertController.textFields.firstObject.text);
//        NSString *currentBidAmount = [NSString stringWithFormat:@"%d",[alertController.textFields.firstObject.text intValue]];
        NSString *maxBid = [NSString stringWithFormat:@"%d",[alertController.textFields.firstObject.text intValue]];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                _currentAuction.auction_id,@"auction_id",
//                                currentBidAmount,@"bid_amount",
                                maxBid,@"auto_bid_amount",
                                nil];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,CREATEAUTOBID];
//        vehicleDetails.current_bid_amount = alertController.textFields.firstObject.text;
        [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
            [lblAutoBid setText:[NSString stringWithFormat:@"$ %@",[alertController.textFields objectAtIndex:0].text]];
            [WSLoading dismissLoading];
            
            NSError* error;
            //        NSString *json = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
            
            NSLog(@"JSON autobid:%@",json);
            if([[json objectForKey:@"success"] isEqualToString:@"true"]) {
                [self playBeep];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"Autobidding started succesfully"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
        
        [[SharedAppDelegate pusherClient] subscribeToChannelNamed:@"auction_wheelslot"];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)carProofClicked:(id)sender {
    CarProofViewController *carProofView = [self.storyboard instantiateViewControllerWithIdentifier:@"CarProofViewController"];
    carProofView.urlString = vehicleDetails.car_proof_link;
    carProofView.mainTitle = @"CarProof";
    if(vehicleDetails.car_proof_link.length > 0){
        [self.navigationController pushViewController:carProofView animated:YES];
    }
}


#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([collapsedSection containsObject:@(section)]) {
        return 0;
    } else {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return vehicleDetails.additional_options.count;
                break;
            case 2:
                return vehicleDetails.standard_features.count;
                break;
            case 3:
                return 1;
                break;
            default:
                return 1;
                break;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfSections;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *mainCell;
    switch (indexPath.section) {
        case 0:{
            SummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SummaryCell"];
            if (cell == nil) {
                // Load the top-level objects from the custom cell XIB.
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SummaryCell" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
                VinDetail *tempVinDetail = vehicleDetails.inventory_data;
                [cell.txtBodyType setText:[NSString stringWithFormat:@"%@",tempVinDetail.bodyType]];
//                [cell.txtComment setText:tempVinDetail.option_description];
                //[cell.txtCylinder setText:[NSString stringWithFormat:@"%@",tempVinDetail.cylinders]];
                [cell.txtEngineType setText:[NSString stringWithFormat:@"%@",tempVinDetail.engine_type]];
                [cell.txtExtColor setText:[NSString stringWithFormat:@"%@",vehicleDetails.vehicle_exterior_color]];
                [cell.txtFuelType setText:[NSString stringWithFormat:@"%@",tempVinDetail.engine_fuel_type]];
                [cell.txtIntColor setText:[NSString stringWithFormat:@"%@",tempVinDetail.interior_color]];
                [cell.txtMake setText:[NSString stringWithFormat:@"%@",vehicleDetails.vehicle_make]];
                [cell.txtMileage setText:[NSString stringWithFormat:@"%@",vehicleDetails.vehicle_mileage]];
                [cell.txtDrivetrain setText:[NSString stringWithFormat:@"%@",vehicleDetails.drivetrain_type]];
                
                if([vehicleDetails.mileage_type isEqualToString:@"miles"]) {
                    [cell.milageSegment setSelected:YES segmentAtIndex:0];
                }else {
                    [cell.milageSegment setSelected:YES segmentAtIndex:1];
                }
                
                
                [cell.txtModel setText:[NSString stringWithFormat:@"%@",vehicleDetails.vehicle_model]];
                [cell.txtVin setText:[NSString stringWithFormat:@"%@",tempVinDetail.vin]];
                
                [cell.txtYear setText:[NSString stringWithFormat:@"%@",vehicleDetails.vehicle_year]];

                
                if([vehicleDetails.vehicle_transmission isEqualToString:@"manual"]) {
                    [cell.transmissionSegment setSelectedSegmentIndex:1];
                } else if([vehicleDetails.vehicle_transmission isEqualToString:@"auto"]) {
                    [cell.transmissionSegment setSelectedSegmentIndex:0];
                } else if([vehicleDetails.vehicle_transmission isEqualToString:@"semi-auto"]) {
                    [cell.transmissionSegment setSelectedSegmentIndex:2];
                } else {
                    [cell.transmissionSegment setSelectedSegmentIndex:1];
                }
                
                if([tempVinDetail.carproof_package isEqualToString:@"claims"]) {
                    [cell.carproofSegment setSelected:YES segmentAtIndex:0];
                }else {
                    [cell.carproofSegment setSelected:YES segmentAtIndex:1];
                }
                
                if([tempVinDetail.vehicle_history isEqualToString:@"no"]) {
                    [cell.historySegment setSelected:YES segmentAtIndex:1];
                }else {
                    [cell.historySegment setSelected:YES segmentAtIndex:0];
                }


                switch ([tempVinDetail.passanger_capacity intValue]) {
                    case 2:
                        [cell.passengerSegment setSelectedSegmentIndex:0];
                        break;
                    case 5:
                        [cell.passengerSegment setSelectedSegmentIndex:1];
                        break;
                    case 6:
                        [cell.passengerSegment setSelectedSegmentIndex:2];
                        break;
                    case 7:
                        [cell.passengerSegment setSelectedSegmentIndex:3];
                        break;
                    
                    case 8:
                        [cell.passengerSegment setSelectedSegmentIndex:4];
                        break;
                        
                    default:
//                        [cell.passengerSegment setSelectedSegmentIndex:99];
                        break;
                }
                
//
            }
            mainCell = cell;
        }
            break;
         
        case 1:{
            FeaturesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeaturesCell"];

            [cell.textLabel setText:[vehicleDetails.additional_options objectAtIndex:indexPath.row]];
            [cell.textLabel setNumberOfLines:0];
            mainCell = cell;
        }

            break;
        case 2:{
            FeaturesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeaturesCell"];

            [cell.textLabel setText:[vehicleDetails.standard_features objectAtIndex:indexPath.row]];
            [cell.textLabel setNumberOfLines:0];

            mainCell = cell;
        }

            break;
        case 3:{
           DisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DisclosureCell"];
           if (cell == nil) {
                // Load the top-level objects from the custom cell XIB.
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DisclosureCell" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            DisclosureData *disclosureData = vehicleDetails.disclosure_data;
            [cell.outOfProvinceSwitch setSelected:YES segmentAtIndex:[WSLoading getBoolValueForKey:disclosureData.disclosure_vehicle_history.out_of_province_vehicle]?0:1];
            
          //  [self.engineRepairSegment setSelected:YES segmentAtIndex:0];

            
            //DisclosureCell
            
            [cell.dailyRentalSwitch  setSelected:YES segmentAtIndex:([WSLoading getBoolValueForKey:disclosureData.disclosure_vehicle_history.daily_rental]?0:1)];
            [cell.fireDamageSwitch setSelected:YES segmentAtIndex:([WSLoading getBoolValueForKey:disclosureData.disclosure_vehicle_history.fire_damaged]?0:1)];
            [cell.immersedInWaterSwitch setSelected:YES segmentAtIndex:[WSLoading getBoolValueForKey:disclosureData.disclosure_vehicle_history.immersed_in_water]?0:1];
            [cell.policeCruiserSwitch setSelected:YES segmentAtIndex:[WSLoading getBoolValueForKey:disclosureData.disclosure_vehicle_history.police_cruiser]?0:1];
            [cell.taxiLimoSwitch setSelected:YES segmentAtIndex:[WSLoading getBoolValueForKey:disclosureData.disclosure_vehicle_history.tax_or_limo]?0:1];
            [cell.theftRecoverySwitch setSelected:YES segmentAtIndex:[WSLoading getBoolValueForKey:disclosureData.disclosure_vehicle_history.theft_recovery]?0:1];
            [cell.airbagMissingSwitch setSelected:YES segmentAtIndex:[WSLoading getBoolValueForKey:disclosureData.disclosure_vehicle_history.airbag_missing_inoperable]?0:1];
            [cell.totalLossSwitch setSelected:YES segmentAtIndex:[WSLoading getBoolValueForKey:disclosureData.disclosure_vehicle_history.total_loss_by_insurer]?0:1];
            
            if([disclosureData.disclosure_vehicle_condition.engine_needs_repair isEqualToString:@"N"]) {
                [cell.engineRepairSegment setSelected:YES segmentAtIndex:1];
            }else {
                [cell.engineRepairSegment setSelected:YES segmentAtIndex:0];
            }
            
            switch ([disclosureData.disclosure_vehicle_condition.windshield_condition intValue]) {
                case 1:
                    [cell.windshieldSegment setSelected:YES segmentAtIndex:0];
                    break;
                case 2:
                    [cell.windshieldSegment setSelected:YES segmentAtIndex:1];
                    break;
                case 3:
                    [cell.windshieldSegment setSelected:YES segmentAtIndex:2];
                    break;
                    
                default:
                    [cell.windshieldSegment setSelected:YES segmentAtIndex:0];
                    break;
            }
            
            switch ([disclosureData.disclosure_vehicle_condition.tire_condition intValue]) {
                case 1:
                    [cell.txtTireCondition setText:@"Good"];
                    break;
                case 2:
                    [cell.txtTireCondition setText:@"Average"];
                    break;
                case 3:
                    [cell.txtTireCondition setText:@"Need 1 Tire"];
                    break;
                case 4:
                    [cell.txtTireCondition setText:@"Need 2 Tire"];
                    break;
                case 5:
                    [cell.txtTireCondition setText:@"Need 3 Tire"];
                    break;
                case 6:
                    [cell.txtTireCondition setText:@"Need 4 Tire"];
                    break;
                default:
                     [cell.txtTireCondition setText:@"Good"];
                    break;
            }
            
            switch ([disclosureData.disclosure_vehicle_declaration.accident_brand intValue]) {
                case 1:
                    [cell.accidentalSegment setSelected:YES segmentAtIndex:0];
                    break;
                case 2:
                    [cell.accidentalSegment setSelected:YES segmentAtIndex:1];
                    break;
                case 3:
                    [cell.accidentalSegment setSelected:YES segmentAtIndex:2];
                    break;
                case 4:
                    [cell.accidentalSegment setSelected:YES segmentAtIndex:3];
                    break;
                default:
                    [cell.accidentalSegment setSelected:YES segmentAtIndex:3];
                    break;
            }
            
            if([disclosureData.disclosure_vehicle_declaration.vehicle_lien isEqualToString:@"N"])
            {
                [cell.vehicleLienSegment setSelected:YES segmentAtIndex:1];
            }else {
                [cell.vehicleLienSegment setSelected:YES segmentAtIndex:0];
            }
            
            if([disclosureData.disclosure_vehicle_declaration.pending_vehicle isEqualToString:@"N"])
            {
                [cell.pendingVehicleSegment setSelected:YES segmentAtIndex:1];
            }else {
                [cell.pendingVehicleSegment setSelected:YES segmentAtIndex:0];
            }
            mainCell = cell;
       }
            break;
        default:
            break;
    }

    return mainCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    CustomSectionHeaderCell *sectionHeader = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    [sectionHeader.lblHeaderTitle setText:[arrHeaderTitle objectAtIndex:section]];
    sectionHeader.btnHeader.tag = section;
    [sectionHeader.btnHeader addTarget:self action:@selector(expandHeader:) forControlEvents:UIControlEventTouchUpInside];
    
    if([collapsedSection containsObject:@(section)]) {
        [sectionHeader.btnHeader setSelected:YES];
    }
    else {
        [sectionHeader.btnHeader setSelected:NO];
    }
    
    return sectionHeader.contentView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([arrCollapsed containsObject:indexPath])
//    {
//        return 0;
//    }
//    else
//    {
//        
//    }
//    CGFloat he;
    
    return UITableViewAutomaticDimension;
}

#pragma mark - Custom Methods

-(void)refresh:(id)sender {
    [sender endRefreshing];
//    [timer invalidate];
    [self getVehicleDetails];
}

-(void)updateCountDown:(id)sender {
    if([lblCountDown.text isEqualToString:@"00:00:00"] || [lblCountDown.text isEqualToString:@"0:0:0"]) {
        [hidBidView setHidden:NO];
        [lblCountDown setText:@"00:00:00"];

        return;
    }
    
    if([vehicleDetails.seller_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
        [hidBidView setHidden:NO];
        [lblNumberOfBids setBackgroundColor:[UIColor grayColor]];
        
    }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSDate *dateFromString = [dateFormatter dateFromString:lblCountDown.text];
      if (dateFromString == nil) {
        [dateFormatter setDateFormat:@"mm:ss"];
        dateFromString = [dateFormatter dateFromString:lblCountDown.text];
      }
    
        
        NSString *tempDate = [dateFormatter stringFromDate:[dateFromString dateByAddingTimeInterval:-1.0]];
    
        [lblCountDown setText:tempDate];
    
}

-(void)createBidWithBidAmount:(NSString *)amount {
    vehicleDetails.current_bid_amount = amount;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _currentAuction.vehicle_id,@"vehicle_id",
                            _currentAuction.car_type,@"car_type",
                            _currentAuction.auction_id,@"auction_id",
                            amount,@"bid_amount",
                            nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,CREATE_BID];
    // Fix this login in future.
    vehicleDetails.current_bid_amount = amount;
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        
        NSLog(@"JSON createBid:%@",json);
        
        if([json objectForKey:@"push_message"]) {
//            vehicleDetails.current_bid_amount = amount;
            [self playBeep];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"You have successfully placed $ %@  bid.", amount] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            if ([[json objectForKey:@"error_message"] length]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[json objectForKey:@"error_message"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            }
            vehicleDetails.current_bid_amount = pastBid;
        }
    }];
    
}

-(void)playBeep {
    //Retrieve audio file
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    avSound = [[AVAudioPlayer alloc]
               initWithContentsOfURL:pathURL error:nil];
    
    [avSound play];

}


-(void)custompostmangetvehicleDetails{
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"AUTH-KEY": @"MTE=",
                               @"cache-control": @"no-cache"
                               };
    
    NSArray *parameters = @[ @{ @"name": @"vehicle_id", @"value": _currentAuction.vehicle_id },
                             @{ @"name": @"car_type", @"value": @"used" },
                             @{ @"name": @"dealer_country", @"value": @"33" },
                             @{ @"name": @"auction", @"value": _currentAuction.auction_id } ];
    
    NSError *error;
    NSMutableString *body = [NSMutableString string];
        for (int i=0; i<parameters.count; i++) {
            NSDictionary *param = parameters[i];
            [body appendFormat:@"%@=", param[@"name"]];
            [body appendFormat:@"%@", param[@"value"]];
            if (i != parameters.count-1) {
                [body appendFormat:@"&"];
            }
        }
    NSLog(@"Body:%@",body);
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,VEHICLE_DETAILS];
//@"http://auction.wheelslot.com/index.php/webserviceV2/vehicleDetailSummary"
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        if (data) {
                                                            NSString *returnstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                            NSLog(@"Response:%@",returnstr);
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}

- (NSString *) createParamString:(NSDictionary *) params{
    
    NSString *result = @"";
    id key;
    NSEnumerator *enumerator = [params keyEnumerator];
    while (key = [enumerator nextObject]) {
        result = [result stringByAppendingFormat:@"%@=%@&", key, [params objectForKey:key]];
    }
    result = [result substringToIndex:[result length] - 1];
    return [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(void)getVehicleDetails {
//    [self custompostmangetvehicleDetails];
    
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"AUTH-KEY": [Login sharedInstance].auth_key,
                               @"cache-control": @"no-cache",
                               };

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _currentAuction.vehicle_id,@"vehicle_id",
                            _currentAuction.car_type,@"car_type",
                            _currentAuction.auction_id,@"auction",
                            _currentAuction.dealer_country,@"dealer_country",
                            nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,VEHICLE_DETAILS];

    NSLog(@"Current body:%@",[self createParamString:params]);
    NSData *postData = [[self createParamString:params] dataUsingEncoding:NSUTF8StringEncoding];


    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:15.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    [WSLoading showLoading];
    /*
    NSDate *startDate = [NSDate date];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSDate *endDate = [NSDate date];
                                                    NSTimeInterval timeInt = [endDate timeIntervalSinceDate:startDate];
                                                    NSLog(@"time Interval : %f",timeInt);
                                                    [WSLoading dismissLoading];
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        if (data) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self setVehicleData:data];
                                                            });
                                                            
//                                                            NSString *returnstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                            NSLog(@"Response:%@",returnstr);
                                                        }
                                                    }
                                                }];
    [dataTask resume];

}

-(void)setVehicleData:(NSData *)data {
     */
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSDate *endDate = [NSDate date];
//        timeInterval = [startDate timeIntervalSinceDate:endDate];
        NSError *error;
        [VehicleDetails resetSharedInstance];
        vehicleDetails = [[VehicleDetails alloc]initWithData:result error:&error];
        if(!error) {
            
            if([_currentAuction.auction_id isEqualToString:@"0"]) {
                [_btnFavorite removeFromSuperview];
                [_btnHistory removeFromSuperview];
            }else {
                [_btnFavorite setHidden:NO];
                [_btnHistory setHidden:NO];
            }
            
            [lblVin setText:[NSString stringWithFormat:@"Vin: %@",vehicleDetails.inventory_data.vin]];
            [lblVehicleName setText:[NSString stringWithFormat:@"%@ %@ %@",vehicleDetails.vehicle_year,vehicleDetails.vehicle_make,vehicleDetails.vehicle_model]];
            if(vehicleDetails.distance.length > 0) {
                [lblDistance setText:[NSString stringWithFormat:@" %@ away",vehicleDetails.distance]];
            }
            
            if([vehicleDetails.need_reapir isEqualToString:@"N"]) {
                [lblWarning setBackgroundColor:[UIColor greenColor]];
            }
            
            if([vehicleDetails.auction_status isEqualToString:@"O"]) {
                if([vehicleDetails.seller_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]] && ([[WSLoading getCurrentUserDetailForKey:@"user_type"] isEqualToString:@"dealer"]
                    || [[WSLoading getCurrentUserDetailForKey:@"user_type"] isEqualToString:@"admin"])) {
                    [btnDelete setHidden:NO];
                }
            }
             if(([vehicleDetails.auction_status isEqualToString:@"U"]) || ([vehicleDetails.auction_status isEqualToString:@"P"])) {
            if([vehicleDetails.seller_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]){
                [btnDelete setHidden:NO];
            }
        }
            if([vehicleDetails.asIs_vehicle isEqualToString:@"Y"]){
                [asIsVehicleImg setHidden:NO];
            }
            
                        
            [lblNumberOfBids setText:vehicleDetails.bid_count];
            [lblDealerName setText:vehicleDetails.dealership_name];
            [lblDealerLocation setText:vehicleDetails.dealer_city];
            [lblMileage setText:[NSString stringWithFormat:@"%@ %@",vehicleDetails.vehicle_mileage,vehicleDetails.mileage_type]];
            [lblExteriorColor setText:[NSString stringWithFormat:@"Ext: %@",vehicleDetails.vehicle_exterior_color]];
            [lblInteriorColor setText:[NSString stringWithFormat:@"Int: %@",vehicleDetails.inventory_data.interior_color]];
            
            [lblQuickBid setText:[NSString stringWithFormat:@"+ $ %d",vehicleDetails.quickBidAmt]];
//            NSMutableAttributedString *newString = [[NSMutableAttributedString alloc] initWithAttributedString:lblComment.attributedText];
//            [newString appendAttributedString: [[NSAttributedString alloc] initWithString:vehicleDetails.inventory_data.option_description]];
            
             lblComment.text = vehicleDetails.option_description;
            
            // lblComment.text = vehicleDetails.inventory_data.option_description;

            if(vehicleDetails.current_bid_amount.length > 0) {
                [lblCurrentBid setText:[NSString stringWithFormat:@"$ %@",vehicleDetails.current_bid_amount]];
            }else {
                [lblCurrentBid setText:@"$ 0"];
            }
            [imgFlag setImageWithURL:vehicleDetails.flag_country];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            if(![vehicleDetails.countdown isEqualToString:@"0:0:0"]) {
                NSDate *dateFromString = [dateFormatter dateFromString:self->vehicleDetails.countdown];
                if (dateFromString == nil) {
                    [dateFormatter setDateFormat:@"mm:ss"];
                    dateFromString = [dateFormatter dateFromString:self->vehicleDetails.countdown];
                }
                
                NSString *tempDate = [dateFormatter stringFromDate:[dateFromString dateByAddingTimeInterval:timeInterval]];
                vehicleDetails.countdown = tempDate;
            }
            
         
            
            
            

            [lblCountDown setText:vehicleDetails.countdown];
            
         
            
            if([WSLoading getBoolValueForKey:vehicleDetails.is_favourite]) {
                [_btnFavorite setSelected:YES];
                [_btnFavorite setImage:[UIImage imageNamed:@"favoriteSelected"] forState:UIControlStateNormal];
            }else {
                
            }
            
            [hidBidView setHidden:NO];
            
            
            
            if(![lblCountDown.text isEqualToString:@"0:0:0"] &&  lblCountDown.text.length>0) {
                [hidBidView setHidden:YES];
                NSDate *dateFromString = [dateFormatter dateFromString:lblCountDown.text];
                
//                NSString *tempDate = [dateFormatter stringFromDate:[dateFromString dateByAddingTimeInterval:timeInterval]];
                 NSString *tempDate = [dateFormatter stringFromDate:dateFromString];
                [lblCountDown setText:tempDate];

               
            }
            if ([_currentAuction.auction_id isEqualToString:@"0"]) {
                [hidBidView setHidden:NO];
            }
            if([vehicleDetails.vehicle_transmission isEqualToString:@"manual"]) {
                [lblTrasnmissionShort setText:@"M"];
            } else if([vehicleDetails.vehicle_transmission isEqualToString:@"auto"]) {
                [lblTrasnmissionShort setText:@"A"];
            } else {
                [lblTrasnmissionShort setText:@"S"];
            }
            
            if(vehicleDetails.car_proof_link.length == 0) {
                [btnCarProof removeFromSuperview];
            }
            
            if([vehicleDetails.my_bid isEqualToString:vehicleDetails.vehicle_price]) {
                [lblNumberOfBids setBackgroundColor:[UIColor colorWithRed:64/255.0 green:128/255.0 blue:0 alpha:1.0]];
            }else {
                [lblNumberOfBids setBackgroundColor:[UIColor redColor]];
            }
            
            if([vehicleDetails.auction_status isEqualToString:@"E"]) {
                if(vehicleDetails.top_two_bidder.count == 2 && [vehicleDetails.top_two_bidder containsObject:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
                    [hidBidView setHidden:YES];
                }
            }
            
            if([vehicleDetails.seller_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
                [hidBidView setHidden:NO];
                [lblNumberOfBids setBackgroundColor:[UIColor grayColor]];
                
            }
                        
            if([vehicleDetails.bidder_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
                [hidBidView setHidden:NO];
                
            }
            
            if([lblNumberOfBids.text isEqualToString:@"0"]) {
                [lblNumberOfBids setBackgroundColor:[UIColor grayColor]];
            }
            
            int imgCount = 0;
            CGRect scrollFrame = _scrollCarImages.frame;
            arrVehicleImages = [NSMutableArray array];
            if(vehicleDetails.images.count > 0) {
                for (ImageInfo *temp in vehicleDetails.images) {
                    
                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollFrame.size.width * imgCount,0,scrollFrame.size.width,scrollFrame.size.height)];
                    imgView.contentMode = UIViewContentModeScaleAspectFit;
                    [imgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?w=800&h=600",temp.imageUrl]]] placeholderImage:[UIImage imageNamed:@"tempCar"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                        if (image) {
                           
                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [imgView setImage:[image imageByScalingAndCroppingForSize:imgView.frame.size]];
                                [imgView setImage:image];
                                 [arrVehicleImages addObject:image];
                                [_scrollCarImages addSubview:imgView];
                            });
                        }else {
                            image = nil;
                        }
                    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                        
                    }];

                    
//                    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?w=800&h=600",temp.imageUrl]]];
//                    [imgView setImage:[imgView.image imageByScalingAndCroppingForSize:imgView.frame.size]];
//                                        if(imgView.image) {
//                        [arrVehicleImages addObject:imgView.image];
//                    }
//                    [_scrollCarImages addSubview:imgView];
                    //                [_scrollCarImages setContentOffset:CGPointMake(scrollFrame.size.width * imgCount,0) animated:YES];
                    imgCount++;
                }
                
            }else {
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollFrame.size.width * imgCount,0,scrollFrame.size.width,scrollFrame.size.height)];
              
                [imgView setImage:[UIImage imageNamed:@"tempCar"]];
                
                [_scrollCarImages addSubview:imgView];
            }
            [_scrollCarImages setContentSize:CGSizeMake(scrollFrame.size.width * imgCount, scrollFrame.size.height)];
            
            
            imgCount = 0;
            CGFloat currentOffset = 0;
            scrollFrame = _damageScrollView.frame;
            arrVehicleImages = [NSMutableArray array];
            if(vehicleDetails.damaged_pictures.count > 0) {
                [lblDamagedImages removeFromSuperview];
                for (ImageInfo *temp in vehicleDetails.damaged_pictures) {
                    
                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(currentOffset, 0, 200, CGRectGetHeight(_damageScrollView.frame))];
                    imgView.contentMode = UIViewContentModeScaleAspectFit;
                    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?w=800&h=600",temp.imageUrl]]];
//                    [imgView setImage:[imgView.image imageByScalingAndCroppingForSize:imgView.frame.size]];
                    [imgView setImage:imgView.image];
                    if(imgView.image) {
                        [arrVehicleImages addObject:imgView.image];
                    }
                    
                    imgView.layer.borderWidth = 5.0;
                    imgView.layer.borderColor = [UIColor colorWithRed:199/255.0 green:54/255.0 blue:46/255.0 alpha:1.0].CGColor;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.clipsToBounds = YES;
//                    imgView.layer.borderWidth = 3.0;
//                    imgView.layer.borderColor = [UIColor yellowColor].CGColor;
                    
                    [_damageScrollView addSubview:imgView];
                currentOffset += CGRectGetWidth(imgView.frame) + 10;
                    //                [_scrollCarImages setContentOffset:CGPointMake(scrollFrame.size.width * imgCount,0) animated:YES];
                
                    imgCount++;
                }
               
                
            }else {
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollFrame.size.width * imgCount,0,scrollFrame.size.width,scrollFrame.size.height)];
                
                [imgView setImage:[UIImage imageNamed:@"tempCar"]];
                
                imgView.layer.borderWidth = 5.0;
                imgView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:7/255.0 alpha:1.0].CGColor;
//                [_damageScrollView addSubview:imgView];
            }
             [_damageScrollView setContentSize:CGSizeMake(currentOffset, CGRectGetHeight(_damageScrollView.frame))];
            
            if (vehicleDetails.disclosure_data) {
                numberOfSections = 4;
            }else {
                numberOfSections = 3;
            }
            
            [_tblDetails reloadData];
        }
    }];
}

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}
- (void)viewDidLayoutSubviews
{
    lblComment.text = vehicleDetails.option_description;

    if ([lblComment.text length]) {
        int increasedHeight = [self getLabelHeight:lblComment];
        if (increasedHeight > 30) {
            increasedHeight += 40;
        }
        // set a frame of this view Like example
        tableViewHeader.frame = CGRectMake(0, 0, tableViewHeader.frame.size.width , 719 + MAX(increasedHeight, 50) );
        self.tblDetails.tableHeaderView = tableViewHeader;
        
    }
    
}
-(NSArray*) indexPathsForSection:(int)section withNumberOfRows:(int)numberOfRows {
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < numberOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

-(void)expandHeader:(UIButton *)sender {
    
    [self.tblDetails beginUpdates];
    sender.selected=!sender.selected;

    int section = sender.tag;
    BOOL shouldCollapse = ![collapsedSection containsObject:@(section)];
    
    if(shouldCollapse) {
        int numOfRows = [self.tblDetails numberOfRowsInSection:section];
        NSArray *indexPath = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.tblDetails deleteRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationTop];
        [collapsedSection addObject:@(section)];
    }
    else {
        int numOfRows;
        switch (section) {
            case 0:
                numOfRows = 1;
                break;
            case 1:
                numOfRows = (int)vehicleDetails.additional_options.count;
                break;
            case 2:
                numOfRows = (int)vehicleDetails.standard_features.count;
                break;
            case 3:
                numOfRows = 1;
                break;
            default:
                numOfRows = 1;
                break;
        }

        NSArray *indexPath = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.tblDetails insertRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationTop];
        [collapsedSection removeObject:@(section)];
    }
    [self.tblDetails endUpdates];
    
//    NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
//    if([arrCollapsed containsObject:temp]) {
//        [arrCollapsed removeObject:temp];
//    }
//    else {
//        [arrCollapsed addObject:temp];
//    }
//
//    NSRange range = NSMakeRange(sender.tag, 1);
//    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
//    [self.tblDetails reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
//    [self.tblDetails reloadData];
}


-(void)backClicked:(id)sender {
    [VehicleDetails resetSharedInstance];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)carImageTapped:(UIGestureRecognizer *)sender {
    
    IDMPhotoBrowser *browser;
    NSMutableArray *arrUrlString = [NSMutableArray array];
    NSMutableArray *arrDamageString = [NSMutableArray array];
    for (ImageInfo __strong *tempInfo in vehicleDetails.images) {
        [arrUrlString addObject:[tempInfo.imageUrl stringByAppendingString:@"?w=800&h=600"]];
    }
    
    for (ImageInfo __strong *tempInfo in vehicleDetails.damaged_pictures) {
        [arrDamageString addObject:[tempInfo.imageUrl stringByAppendingString:@"?w=800&h=600"]];
    }
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    if(sender.view == _scrollCarImages) {
       // CGSize size = _scrollCarImages.contentOffset
        
        if(vehicleDetails.images.count > 0) {
            CGPoint touchPoint = [sender locationInView: _scrollCarImages];
            int photoIndex = touchPoint.x / screenSize.width;
            NSLog(@"%f , %f %d",touchPoint.x,touchPoint.y,photoIndex);
           browser = [[IDMPhotoBrowser alloc]initWithPhotoURLs:arrUrlString animatedFromView:_scrollCarImages];
            [browser setInitialPageIndex:photoIndex];
            
        }else{
            return;
        }
    }else {
        
        if(vehicleDetails.damaged_pictures.count > 0) {
            CGPoint touchPoint = [sender locationInView: _damageScrollView];
            int photoIndex = touchPoint.x / ((screenSize.width/2 ) - 40);
            NSLog(@"%f , %f %d",touchPoint.x,touchPoint.y,photoIndex);
            
            
            browser = [[IDMPhotoBrowser alloc]initWithPhotoURLs:arrDamageString animatedFromView:_damageScrollView];
            [browser setInitialPageIndex:photoIndex];

        }else{
            return;
        }

    }
    
    browser.displayActionButton = NO;
    browser.displayArrowButton = YES;
    browser.displayCounterLabel = NO;
    browser.displayDoneButton = YES;
    browser.usePopAnimation = YES;
    [self presentViewController:browser animated:YES completion:nil];
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
