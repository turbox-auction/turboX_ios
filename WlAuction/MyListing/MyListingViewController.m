//
//  MyListingViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 08/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "MyListingViewController.h"
#import "InventoryCell.h"
#import "UIImage+Blur.h"
#import "DetailViewController.h"
#import "WSLoading.h"
#import "AllAuctions.h"
#import "UIImageView+AFNetworking.h"
#import "AllBids.h"
#import "BidHistoryViewController.h"
#import "UIImage+Resize.h"
#import "AddCarDetailViewController.h"
#import "AppDelegate.h"

typedef enum {
Live,
Selling,
Sold,
Delivered,
Pending
}AuctionType;



//typedef enum {
//    Delivered,
//    Sold,
//    Live,
//    Upcoming,
//    OffAcution,
//    Selling,
//    Extended,
//    Pending
//}AuctionType;

#define auctionTypeString(enum)[@[@"live",@"selling",@"sold",@"delivered"] objectAtIndex:enum] //[@[@"delivered",@"sold",@"Upcoming",@"off",@"selling",@"extended",@"pending",@"live"] objectAtIndex:enum]


@interface MyListingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrAuctionState;
    NSMutableArray *arrAuctions;
    int record,limit,currentPage;
    UIBarButtonItem *rightBarButton;
    UIBarButtonItem *moreBarButton;
    
    NSTimer *timer;
    NSTimeInterval timeInterval;
    
    float timeTakenByWS;
    float timeTakenToLoadCell;
}
@property (weak, nonatomic) IBOutlet UITableView *tblListing;


@property (nonatomic, assign) AuctionType auctionType;

@end

@implementation MyListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateCountDown:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    arrAuctionState = [NSArray arrayWithObjects:@"Delivered",@"Sold",@"Off Auction",@"Selling" ,nil];
    self.auctionType = Live;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_tblListing addSubview:refreshControl];
    arrAuctions = [NSMutableArray array];
    [self getMyListing];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
//    self.auctionType = Selling;
    [self.tabBarController setTitle:@"SELL"];
    
    // Add bar button items
    
    rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter1"] style:UIBarButtonItemStylePlain target:self action:@selector(filterAllActivity:)];
    moreBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More_White"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked:)];
    
   UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Home_White"] style:UIBarButtonItemStylePlain target:self action:@selector(homeBtnClicked:)];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = homeBarButton;

    
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBarButton,rightBarButton,nil];

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

#pragma mark - UITableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(_auctionType == Default) {
//        return 4;
//    }
//    return 1;
    return arrAuctions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OffAuctionCell" forIndexPath:indexPath];
    
        if(arrAuctions.count>0) {
            Auction *tempAuction = (Auction *)[arrAuctions objectAtIndex:indexPath.row];
            
            [cell.lblCountdown setText:tempAuction.countdown];

            [cell.lblBidReceived setText:tempAuction.bid_received];
            [cell.lblBidReceived setBackgroundColor:[UIColor grayColor]];
            [cell.lblCarName setText:[NSString stringWithFormat:@"%@ %@ %@",tempAuction.vehicle_year,tempAuction.vehicle_make,tempAuction.vehicle_model]];
            [cell.lblDealerName setText:tempAuction.vehicle_dealer_id];
            if(tempAuction.distance.length > 0) {
                [cell.lblDistance setText:[NSString stringWithFormat:@"| %@ away",tempAuction.distance]];
            }
            [cell.lblMileage setText:[NSString stringWithFormat:@"MILEAGE: %@ %@",tempAuction.vehicle_mileage,tempAuction.mileage_type]];
            
            if(tempAuction.vehicle_price) {
                [cell.lblPrice setText:[NSString stringWithFormat:@"$ %@",tempAuction.vehicle_price]];
                 [cell.btnSellThis setHidden:NO];
            }else {
                [cell.lblPrice setText:@"$ 0"];
                 [cell.btnSellThis setHidden:YES];
            }
            
            
            if([cell.lblCountdown.text isEqualToString:@"00:00:00"] || [cell.lblCountdown.text isEqualToString:@"0:0:0"]){
                [cell.lblAuctionState setText:[WSLoading convertToStringAuctionStatus:tempAuction.auction_status]];
            }else {
                [cell.lblAuctionState setText:@"LIVE"];
            }
            
            [cell.lblExtColor setText:[NSString stringWithFormat:@"EXTERIOR: %@",tempAuction.vehicle_exterior_color].uppercaseString];
            [cell.lblIntColor setText:[NSString stringWithFormat:@"INTERIOR: %@",tempAuction.vehicle_interior_color].uppercaseString];
            [cell.lblTransmission setText:[NSString stringWithFormat:@"TRANSMISSION: %@",tempAuction.vehicle_transmission].uppercaseString];
            
            NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?w=%d&h=%d",tempAuction.vehicle_images,(int)CGRectGetWidth(cell.imgCar.frame) * 3,(int)CGRectGetHeight(cell.imgCar.frame) * 3]];
            NSURLRequest *imgUrlRequest = [NSURLRequest requestWithURL:imgUrl];
            
            [cell.imgCar setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                
//                [cell.imgCar setImage:[image imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
                [cell.imgCar setImage:image];
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"Error Image:%@",error.localizedDescription);
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
                [cell.lblTransmission setTextColor:[UIColor blackColor]];
                [cell.lblCarName setTextColor:[UIColor blackColor]];
                [cell.lblDealerName setTextColor:[UIColor blackColor]];
                [cell.lblMileage setTextColor:[UIColor blackColor]];
                [cell.lblExtColor setTextColor:[UIColor blackColor]];
                [cell.lblIntColor setTextColor:[UIColor blackColor]];
                [cell.btnHistory setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
                [cell.btnAuction setTitleColor:[UIColor colorWithRed:255/255.0 green:198/255.0 blue:19/255.0 alpha:1.0] forState:UIControlStateNormal];
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
            
            
            if(tempAuction.vehicle_price && [tempAuction.auction_status isEqualToString:@"O"] && [tempAuction.countdown isEqualToString:@"0:0:0"]) {
                
                [cell.btnSellThis setHidden:NO];
            }else {
                
                [cell.btnSellThis setHidden:YES];
            }
            
            
            if([tempAuction.auction_status isEqualToString:@"O"] && [tempAuction.countdown isEqualToString:@"0:0:0"]) {
                [cell.btnHistory setHidden:NO];
               
                [cell.btnParkThis setHidden:NO];
                [cell.btnRelaunchThis setHidden:NO];
            }else {
                [cell.btnHistory setHidden:YES];
                [cell.btnParkThis setHidden:YES];
                [cell.btnRelaunchThis setHidden:YES];
            }
            
            
//            if(self.auctionType == OffAcution) {
//                [cell.btnHistory setHidden:NO];
//                [cell.btnSellThis setHidden:NO];
//                [cell.btnParkThis setHidden:NO];
//            }else {
//                [cell.btnHistory setHidden:YES];
//                [cell.btnSellThis setHidden:YES];
//                [cell.btnParkThis setHidden:YES];
//            }
            
            if(self.auctionType == Pending) {
                cell.btnExtra.hidden = NO;
                cell.btnExtra.tag = indexPath.row;
                [cell.btnExtra setTitle:@"In Stock" forState:UIControlStateNormal];
                [cell.btnExtra addTarget:self action:@selector(addInStock:) forControlEvents:UIControlEventTouchUpInside];
            }else if (self.auctionType == Sold) {
                cell.btnExtra.hidden = NO;
                cell.btnExtra.tag = indexPath.row;
                [cell.btnExtra setTitle:@"Delivered" forState:UIControlStateNormal];
                [cell.btnExtra addTarget:self action:@selector(markDelivered:) forControlEvents:UIControlEventTouchUpInside];

            }
            else {
                cell.btnExtra.hidden = YES;

            }
            
            cell.btnHistory.tag = indexPath.row;
            [cell.btnHistory addTarget:self action:@selector(showHistory:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnSellThis.tag = indexPath.row;
            [cell.btnSellThis addTarget:self action:@selector(sellThis:) forControlEvents:UIControlEventTouchUpInside];
        
            cell.btnParkThis.tag = indexPath.row;
            [cell.btnParkThis addTarget:self action:@selector(parkThis:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.btnRelaunchThis.tag = indexPath.row;
            [cell.btnRelaunchThis addTarget:self action:@selector(relaunchThis:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if(indexPath.row == arrAuctions.count - 1)
            {
                currentPage = currentPage + limit;
                if(!record<limit) {
                    [self getMyListing];
                }
                
            }
            
        }
        return cell;
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(self.auctionType == OffAcution && ([[WSLoading getCurrentUserDetailForKey:@"dealer_type"] isEqualToString:@"dealer"] || [[WSLoading getCurrentUserDetailForKey:@"dealer_type"] isEqualToString:@"admin"])) {
//        return YES;
//    }else {
//        return NO;
//    }
//    
//}
//
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        //add code here for when you hit delete
//        Auction *tempAuction = [arrAuctions objectAtIndex:indexPath.row];
//        [self auctionParkSell:DELETEAUCTION andAuction:tempAuction.auction_id];
//        [arrAuctions removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    }
//}
//
//
#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Auction *tempAuction = [arrAuctions objectAtIndex:indexPath.row];
    DetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailView.currentAuction = tempAuction;
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - Custom Methods

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
    for (InventoryCell *cell in [self.tblListing visibleCells]) {
        NSIndexPath *indexPath = [self.tblListing indexPathForCell:cell];
        
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

-(void)getMyListing {
    
    NSDate *startDate = [NSDate date];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,MY_LISTING];

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
            
            
            if([ auctionTypeString(self.auctionType) isEqualToString: @"selling"]){
                
                
                NSArray *filtered = [allAuctions.activity_auction filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(auction_status == %@)", @"O"]];
                
                NSLog(@"filteredData:%@",filtered);
                
                NSArray *filtered2 = [filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(countdown == %@)", @"0:0:0"]];
                
                [arrAuctions addObjectsFromArray:filtered2];
                
                
            }else{
                
               [arrAuctions addObjectsFromArray:allAuctions.activity_auction];
                
            }
        
            if(arrAuctions.count == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }

            [_tblListing reloadData];
        }else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}

-(void)getFilteredListing {
    currentPage = 0;
    arrAuctions = [NSMutableArray array];
    [self getMyListing];
}

-(void)refresh:(id)sender {
    [sender endRefreshing];
    currentPage = 0;
    arrAuctions = [NSMutableArray array];
    [self getMyListing];
//    [_tblListing reloadData];
}

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sellThis:(UIButton *)sender {
    Auction *tempAuction = [arrAuctions objectAtIndex:sender.tag];
    //[self auctionParkSell:SELLAUCTION andAuction:tempAuction.auction_id];
    [self auctionParkSell:REALSELLAUCTION andAuction:tempAuction.auction_id  baseURL:YES];

}

-(void)relaunchThis:(UIButton *)sender {
    //    Auction *tempAuction = [arrAuctions objectAtIndex:sender.tag];
    //    [self auctionParkSell:PARKAUCTION andAuction:tempAuction.auction_id];
    [self relaunchCar:sender.tag];
    
}


-(void)parkThis:(UIButton *)sender {
    Auction *tempAuction = [arrAuctions objectAtIndex:sender.tag];
    NSString *auction_id =  tempAuction.auction_id ;
    NSLog(@"auction_id:%@",auction_id);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            tempAuction.auction_id,@"auction_id",
                            nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,PARK_NOW];
    //http://dev.turbox.ca/index.php/webserviceV2/schedule_now?auction_id=179
    
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        
        NSLog(@"JSON:%@",json);
        if(!error) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"Your Vehicle has been Park successfully" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                currentPage = 0;
                arrAuctions = [NSMutableArray array];
                 [self getMyListing];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];

}
-(void)relaunchCar:(NSUInteger)indexRow {
    
    Auction *_currentAuction = [arrAuctions objectAtIndex:indexRow];
    AddCarDetailViewController *addCarDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarDetailViewController"];
    addCarDetail.currentAuction = _currentAuction;
    [self.navigationController pushViewController:addCarDetail animated:YES];
    
}

-(void)markDelivered:(UIButton *)sender {
    Auction *tempAuction = [arrAuctions objectAtIndex:sender.tag];
    [self auctionParkSell:MARKDELIVERED andAuction:tempAuction.auction_id baseURL:NO];
}
-(void)auctionParkSell:(NSString *)type andAuction:(NSString *)auction baseURL:(BOOL)isChnage{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,type];
    if (isChnage){
        urlString = [NSString stringWithFormat:@"%@",type];
    }
    
    NSDictionary *params = @{@"auction_id":auction};
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        
        NSLog(@"JSON:%@",json);
        if(!error) {
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:[json objectForKey:@"success_message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                currentPage = 0;
                arrAuctions = [NSMutableArray array];
                [self getMyListing];
            }]];
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    }];
}

-(void)addInStock:(UIButton *)sender {
    
    Auction *tempAuction = [arrAuctions objectAtIndex:sender.tag];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,MARKINSTOCK];
    
    NSDictionary *params = @{@"vehicle_id":tempAuction.vehicle_id,
                             @"vehicle_type":tempAuction.car_type};
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        
        NSLog(@"JSON:%@",json);
        if(!error) {
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:[json objectForKey:@"success_message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.tblListing reloadData];
            }]];
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    }];
}

-(void)moreBtnClicked:(id)sender {
    [myappDelegate moreBtnClicked:nil];

}
-(void)homeBtnClicked:(id)sender {
    [myappDelegate homeBtnClicked:nil];
}

-(void)filterAllActivity:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
   

    
//    [alert addAction:[UIAlertAction actionWithTitle:@"Upcoming" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.auctionType = Upcoming;
//        [self getFilteredListing];
//        //                [_tblListing reloadData];
//    }]];
    
//    [alert addAction:[UIAlertAction actionWithTitle:@"Off Auction" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                self.auctionType = OffAcution;
//        [self getFilteredListing];
////                [_tblListing reloadData];
//    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Live" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.auctionType = Live;
        [self getFilteredListing];
//                [_tblListing reloadData];
    }]];
  /*
    [alert addAction:[UIAlertAction actionWithTitle:@"Extended" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.auctionType = Extended;
        [self getFilteredListing];
//                [_tblListing reloadData];
    }]];*/
    
        [alert addAction:[UIAlertAction actionWithTitle:@"Pending" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.auctionType = Selling;
            [self getFilteredListing];
    //                [_tblMyBid reloadData];
        }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Sold" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.auctionType = Sold;
        [self getFilteredListing];
        //                [_tblListing reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Delivered" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.auctionType = Delivered;
        [self getFilteredListing];
        //                [_tblListing reloadData];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        self.auctionType = Extended;
//        [self getFilteredListing];
        //                [_tblListing reloadData];
    }]];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //activity.popoverPresentationController.sourceView = shareButtonBarItem;
        alert.modalPresentationStyle = UIModalPresentationPopover;
        alert.popoverPresentationController.barButtonItem = rightBarButton;
        alert.popoverPresentationController.sourceView = self.view;
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self presentViewController:alert animated:YES completion:nil];
    }

}

//-(NSString *)updateTimer {
//    NSDate *now = [NSDate date];
//    
//    NSDate *afterHour = [now dateByAddingTimeInterval:60 * 60 * -1];
//    
//    
//    
////    NSString *answer = [NSString stringWithFormat:@"seconds left = %f", secondsLeft];
//    return @"";
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
