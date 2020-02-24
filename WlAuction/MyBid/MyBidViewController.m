//
//  MyBidViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 05/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "MyBidViewController.h"
#import "UIImage+Blur.h"
#import "UIImage+Resize.h"
#import "InventoryCell.h"
#import "DetailViewController.h"
#import "WSLoading.h"
#import "AllAuctions.h"
#import "UIImageView+AFNetworking.h"
#import "AllBids.h"
#import "BidHistoryViewController.h"
#import "AppDelegate.h"

typedef enum {
    Arrived = 0,
    Live,
    Upcoming,
    Won,
    Lost,
    Pending,
    MyBids,
    Extended,
    Removed
}AuctionType;

#define auctionTypeString(enum) [@[@"arrived",@"live",@"upcoming",@"won",@"lost",@"pending",@"mybids",@"extended",@"removed"] objectAtIndex:enum]

@interface MyBidViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrAuctionState;
    NSMutableArray *arrAuctions;
    int record,limit,currentPage;
    UIBarButtonItem *rightBarButton;
    UIBarButtonItem *moreBarButton;
    NSTimer *timer;
    NSTimeInterval timeInterval;
}
@property (weak, nonatomic) IBOutlet UITableView *tblMyBid;

@property (nonatomic, assign) AuctionType auctionType;

@end

@implementation MyBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrAuctionState = [NSArray arrayWithObjects:@"Won",@"Lost",@"Arrived",@"Pending" ,nil];
    _auctionType = Live;
    
    timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateCountDown:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_tblMyBid addSubview:refreshControl];
    [_tblMyBid.tableFooterView addSubview:refreshControl];
    currentPage = 0;
    arrAuctions = [NSMutableArray array];
    [self getMyBids];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tabBarController setTitle:@"BUY"];
    
    // Add bar button items
    rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter1"] style:UIBarButtonItemStylePlain target:self action:@selector(filterAllActivity:)];
    
    moreBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More_White"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked:)];
    
    
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBarButton,rightBarButton,nil];
    
    UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Home_White"] style:UIBarButtonItemStylePlain target:self action:@selector(homeBtnClicked:)];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = homeBarButton;

    
    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItems = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [timer invalidate];
    timer = nil;
}

#pragma mark - Custom Selector
-(void)showHistory:(UIButton *)sender {
    Auction *tempAuction = [arrAuctions objectAtIndex:sender.tag];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            tempAuction.car_type,@"car_type",
                            tempAuction.auction_id,@"auction_id",
                            tempAuction.dealer_country,@"dealer_country",
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
//            bidHistoryView.vehicleName = [NSString stringWithFormat:@"%@ %@ %@",tempAuction.vehicle_year,tempAuction.vehicle_make,tempAuction.vehicle_model];
            bidHistoryView.vinNumber = allBids.vehicle_vin;
            bidHistoryView.vehicleName = allBids.vehicle_name;
            [self.navigationController pushViewController:bidHistoryView animated:YES];
        }
    }];

}

-(void)updateCountDown:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    for (Auction *tempAuction in arrAuctions) {
        if(![tempAuction.countdown isEqualToString:@"0:0:0"]) {
            NSDate *dateFromString = [dateFormatter dateFromString:tempAuction.countdown];
            NSString *tempDate = [dateFormatter stringFromDate:[dateFromString dateByAddingTimeInterval:-1.0]];
//            NSLog(@"tempDate in Listing:%@",tempDate);
            if(![tempAuction.countdown isEqualToString:@"00:00:00"]){
                tempAuction.countdown = tempDate;
            }
        }else {
            tempAuction.countdown = @"0:0:0";
        }
    }
    for (InventoryCell *cell in [self.tblMyBid visibleCells]) {
        NSIndexPath *indexPath = [self.tblMyBid indexPathForCell:cell];
        
        if([cell.lblCountdown.text isEqualToString:@"0:0:0"]) {
            [cell.lblCountdown setText:@"0:0:0"];
            
        }
        if([cell.lblCountdown.text isEqualToString:@"00:00:00"]) {
            {
                [cell.lblCountdown setText:@"0:0:0"];
            }
            
        }
        
        
        if(arrAuctions.count > 0) {
            if(![cell.lblCountdown.text isEqualToString:@"0:0:0"]) {
                [cell.lblCountdown setText:[[arrAuctions objectAtIndex:indexPath.row] countdown]];
            }else {
                [cell.lblCountdown setText:@"0:0:0"];
            }
            //             [self.tblListing reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(void)getMyBids {
    NSDate *startDate = [NSDate date];

    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,MY_BID];

    NSDictionary *params = @{@"dealer_country":[WSLoading getCurrentUserDetailForKey:@"dealer_country"],
                             @"offset":[NSNumber numberWithInt:currentPage],
                             @"filter":auctionTypeString(self.auctionType)};
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError *error;
        AllAuctions *allAuctions = [[AllAuctions alloc]initWithData:result error:&error];
        if(!error) {
            record = [allAuctions.per_page_records intValue];
            limit = [allAuctions.per_page_limit intValue];
            NSDate *endDate = [NSDate date];
            timeInterval = [startDate timeIntervalSinceDate:endDate];
            NSLog(@"TimeInterval:%f",timeInterval);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            
            for (Auction *tempAuction in allAuctions.activity_auction) {
                if(![tempAuction.countdown isEqualToString:@"0:0:0"]) {
                    NSDate *dateFromString = [dateFormatter dateFromString:tempAuction.countdown];
                    NSString *tempDate = [dateFormatter stringFromDate:[dateFromString dateByAddingTimeInterval:timeInterval]];
                    tempAuction.countdown = tempDate;
                }
            }
            
              if([ auctionTypeString(self.auctionType) isEqualToString: @"mybids"]){
                  
                  NSArray *filtered = [allAuctions.activity_auction filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(auction_status == %@)", @"O"]];
                  
                   NSArray *filtered2 = [filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(countdown == %@)", @"0:0:0"]];
                  
                  NSLog(@"filteredData:%@",filtered);
                  
                  [arrAuctions addObjectsFromArray:filtered2];
            
              }else{
                  
                  NSArray *filtered = [allAuctions.activity_auction filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(auction_status != %@)", @"C"]];
                  
                  NSLog(@"filteredData:%@",filtered);
                  
                  [arrAuctions addObjectsFromArray:filtered];
                  
              }
            
            
            
         
            

          //  [arrAuctions addObjectsFromArray:allAuctions.activity_auction];
            
            if(arrAuctions.count == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            [_tblMyBid reloadData];
        }else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}

-(void)getRemovedVehicle {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,REMOVEDVEHICLES];

    NSDictionary *params = @{@"dealer_country":[WSLoading getCurrentUserDetailForKey:@"dealer_country"],
                             @"offset":[NSNumber numberWithInt:currentPage],
                             };
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError *error;
        AllAuctions *allAuctions = [[AllAuctions alloc]initWithData:result error:&error];
        if(!error) {
            record = [allAuctions.per_page_records intValue];
            limit = [allAuctions.per_page_limit intValue];
            [arrAuctions addObjectsFromArray:allAuctions.buy_pending];
            if(arrAuctions.count == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            [_tblMyBid reloadData];
        }else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}

-(void)getFilteredBids {
    currentPage = 0;
    arrAuctions = [NSMutableArray array];
    if(self.auctionType == Removed) {
        [self getRemovedVehicle];
    }else {
        [self getMyBids];
    }
}

-(void)refresh:(id)sender {
    [sender endRefreshing];
    currentPage = 0;
    arrAuctions = [NSMutableArray array];
    if(self.auctionType == Removed) {
        [self getRemovedVehicle];
    }else {
        [self getMyBids];
    }
//    [_tblMyBid reloadData];
}
-(void)moreBtnClicked:(id)sender {
    [myappDelegate moreBtnClicked:nil];

}
-(void)homeBtnClicked:(id)sender {
    [myappDelegate homeBtnClicked:nil];
}
-(void)filterAllActivity:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@" All Bids" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                self.auctionType = MyBids;
//        [self getFilteredBids];
//           //    [_tblMyBid reloadData];
//    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Live" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.auctionType = Live;
        [self getFilteredBids];
        //                [_tblMyBid reloadData];
    }]];
    
    
//    [alert addAction:[UIAlertAction actionWithTitle:@"Upcoming" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.auctionType = Upcoming;
//        [self getFilteredBids];
//        //                [_tblMyBid reloadData];
//    }]];
//
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Pending" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.auctionType = MyBids;
        [self getFilteredBids];
        //                [_tblMyBid reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Won" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.auctionType = Won;
        [self getFilteredBids];
//                [_tblMyBid reloadData];
    }]];
    
//    [alert addAction:[UIAlertAction actionWithTitle:@"Lost" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                self.auctionType = Lost;
//        [self getFilteredBids];
////                [_tblMyBid reloadData];
//    }]];
//
 
  /*  [alert addAction:[UIAlertAction actionWithTitle:@"Extended" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.auctionType = Extended;
        [self getFilteredBids];
//                [_tblMyBid reloadData];
    }]];*/
    [alert addAction:[UIAlertAction actionWithTitle:@"Arrived" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.auctionType = Arrived;
        [self getFilteredBids];
        //                [_tblMyBid reloadData];
    }]];

//    [alert addAction:[UIAlertAction actionWithTitle:@"Removed Vehicles" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.auctionType = Removed;
//        [self getFilteredBids];
//        //                [_tblMyBid reloadData];
//    }]];
//
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                self.auctionType = MyBids;
//                [_tblMyBid reloadData];
    }]];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //activity.popoverPresentationController.sourceView = shareButtonBarItem;
        
        CGRect frame = [[sender valueForKey:@"view"] frame];
        frame.origin.y = frame.origin.y + 20;
        
//        UIPopoverPresentationController *popoverController =
//        imagePicker.popoverPresentationController;
//        popoverController.sourceView = self.view;
//        popoverController.sourceRect = frame;
        
        alert.modalPresentationStyle = UIModalPresentationPopover;
        alert.popoverPresentationController.sourceRect = frame;
        alert.popoverPresentationController.sourceView = self.view;
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(_auctionType == MyBids) {
//        return 4;
//    }
//    return 1;
    return arrAuctions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BidCell"];
    
    if(arrAuctions.count > 0) {
        
        Auction *tempAuction = [arrAuctions objectAtIndex:indexPath.row];
        [cell.lblCountdown setText:tempAuction.countdown];
        [cell.lblBidReceived setText:tempAuction.bid_received];
        [cell.lblCarName setText:[NSString stringWithFormat:@"%@ %@ %@",tempAuction.vehicle_year,tempAuction.vehicle_make,tempAuction.vehicle_model]];
        [cell.lblDealerName setText:tempAuction.vehicle_dealer_id];
        if(tempAuction.distance.length > 0) {
            [cell.lblDistance setText:[NSString stringWithFormat:@"| %@ away",tempAuction.distance]];
        }
        [cell.lblMileage setText:[NSString stringWithFormat:@"MILEAGE: %@ %@",tempAuction.vehicle_mileage,tempAuction.mileage_type]];
        
        if(tempAuction.vehicle_price) {
            [cell.lblPrice setText:[NSString stringWithFormat:@"$ %@",tempAuction.vehicle_price]];
        }else {
            [cell.lblPrice setText:@"$ 0"];
        }
        
       // [cell.lblPrice setText:[NSString stringWithFormat:@"$ %@",tempAuction.vehicle_price]];
        
        if(cell.lblCountdown.text == nil) {
            [cell.lblAuctionState setText:[WSLoading convertToStringAuctionStatus:tempAuction.auction_status]];
        }else {
            if([cell.lblCountdown.text isEqualToString:@"00:00:00"] || [cell.lblCountdown.text isEqualToString:@"0:0:0"]){
                [cell.lblAuctionState setText:[WSLoading convertToStringAuctionStatus:tempAuction.auction_status]];
            }else {
                [cell.lblAuctionState setText:@"LIVE"];
            }
        }
        
        
         NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?w=%d&h=%d",tempAuction.vehicle_images,(int)CGRectGetWidth(cell.imgCar.frame) * 3,(int)CGRectGetHeight(cell.imgCar.frame) * 3]];
        NSURLRequest *imgUrlRequest = [NSURLRequest requestWithURL:imgUrl];
        
        [cell.imgCar setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
//            [cell.imgCar setImage:[image imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
            [cell.imgCar setImage:image];
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"Error:%@",error.localizedDescription);
                cell.imgCar = nil;
        }];
        
        imgUrlRequest = [NSURLRequest requestWithURL:tempAuction.flag_country];
        
        [cell.imgFlag setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            [cell.imgFlag setImage:image];
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error.localizedDescription);
            cell.imgCar = nil;
        }];

        
        if(indexPath.row % 2) {
            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            [cell.lblCarName setTextColor:[UIColor blackColor]];
            [cell.lblTransmission setTextColor:[UIColor blackColor]];
            [cell.lblDealerName setTextColor:[UIColor blackColor]];
            [cell.lblMileage setTextColor:[UIColor blackColor]];
            [cell.lblExtColor setTextColor:[UIColor blackColor]];
            [cell.lblIntColor setTextColor:[UIColor blackColor]];
            [cell.btnHistory setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
        }else{
            
            cell.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
            [cell.lblCarName setTextColor:[UIColor blackColor]];
            [cell.lblTransmission setTextColor:[UIColor blackColor]];
            [cell.lblDealerName setTextColor:[UIColor blackColor]];
            [cell.lblMileage setTextColor:[UIColor blackColor]];
            [cell.lblExtColor setTextColor:[UIColor blackColor]];
            [cell.lblIntColor setTextColor:[UIColor blackColor]];
            [cell.btnHistory setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
        }

        cell.btnHistory.tag = indexPath.row;
        [cell.btnHistory addTarget:self action:@selector(showHistory:) forControlEvents:UIControlEventTouchUpInside];
        
        if([tempAuction.my_bid isEqualToString:tempAuction.vehicle_price]) {
            
            [cell.lblBidReceived setBackgroundColor:[UIColor colorWithRed:64/255.0 green:128/255.0 blue:0 alpha:1.0]];
        }else {
            [cell.lblBidReceived setBackgroundColor:[UIColor redColor]];
        }
        
        if([cell.lblBidReceived.text isEqualToString:@"0"]){
            [cell.lblBidReceived setBackgroundColor:[UIColor grayColor]];
        }
        
    if([tempAuction.auction_dealer_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
            [cell.lblBidReceived setBackgroundColor:[UIColor grayColor]];
        }
        
        [cell.lblExtColor setText:[NSString stringWithFormat:@"EXTERIOR: %@",tempAuction.vehicle_exterior_color].uppercaseString];
        [cell.lblIntColor setText:[NSString stringWithFormat:@"INTERIOR: %@",tempAuction.vehicle_interior_color].uppercaseString];
        [cell.lblTransmission setText:[NSString stringWithFormat:@"TRANSMISSION: %@",tempAuction.vehicle_transmission].uppercaseString];
        
        if(indexPath.row == arrAuctions.count - 1)
        {
            currentPage = currentPage + limit;
            if(!record<limit) {
                if(self.auctionType == Removed) {
                    [self getRemovedVehicle];
                }else {
                    [self getMyBids];
                }
            }
            
        }
    }
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Auction *tempAuction = [arrAuctions objectAtIndex:indexPath.row];
    DetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailView.currentAuction = tempAuction;
    [self.navigationController pushViewController:detailView animated:YES];
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
