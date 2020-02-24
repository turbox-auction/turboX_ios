//
//  AllActivityViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 04/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "AllActivityViewController.h"
#import "ActivityCollectionViewCell.h"
#import "PPiFlatSegmentedControl.h"
#import "DetailViewController.h"
#import "InventoryCell.h"
#import "UIImage+Blur.h"
#import "UIImage+Resize.h"
#import "WSLoading.h"
#import "AllAuctions.h"
#import "UIImageView+AFNetworking.h"
#include "Pusher.h"
#import "AllBids.h"
#import "BidHistoryViewController.h"
#import "AddCarDetailViewController.h"

typedef enum {
    AllActivity= 0,
    Selling,
    Buying
}FilterType;

 // MyBid

#define filterTypeString(enum) [@[@"",@"selling",@"buying"] objectAtIndex:enum]

//,@"mybid"

@interface AllActivityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
{
    NSString *activityType,*filter;
    NSMutableArray *arrActiveAuctions,*arrAuctions, *arrUpcoming, *filterArrMyBid;
    int record,limit,currentPage;
    UIBarButtonItem *rightBarButton;
    UIBarButtonItem *moreBarButton;
    NSTimer *timer;
    NSTimeInterval timeInterval;
    
    NSString *myBidStr ;
}

@property (weak, nonatomic) IBOutlet UICollectionView *allActivityCollectionView;

@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *allActivitySegmentControl;

@property (weak, nonatomic) IBOutlet UITableView *tblOffAuction;

@property (weak, nonatomic) IBOutlet UIScrollView *allActivityScrollView;

@property (nonatomic, assign) FilterType filterType;
@end

@implementation AllActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                             target:[self view]
//                                           selector:@selector(reloadCollectionData:)
//                                           userInfo:nil
//                                            repeats:YES];

    timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateCountDown:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    [_allActivityCollectionView registerNib:[UINib nibWithNibName:@"ActivityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    _tblOffAuction.estimatedRowHeight = 180;
    _tblOffAuction.rowHeight = UITableViewAutomaticDimension;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
     [_tblOffAuction addSubview:refreshControl];
    
    UIRefreshControl *colRefreshControl = [[UIRefreshControl alloc] init];
    [colRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
   
    [_allActivityCollectionView addSubview:colRefreshControl];
//    filter = filterTypeString(0);
//    activityType = @"";
//    arrAuctions = [NSMutableArray array];
//    [self getAuctions];
        arrAuctions = [NSMutableArray array];
        arrUpcoming = [NSMutableArray array];
    

}

-(void)updateCountDown:(id)sender {
    
    if(_allActivitySegmentControl.selectedSegmentIndex == 0) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    for (Auction *tempAuction in arrActiveAuctions) {
        if(![tempAuction.countdown isEqualToString:@"0:0:0"]) {
            NSDate *dateFromString = [dateFormatter dateFromString:tempAuction.countdown];
            if (dateFromString == nil) {
                [dateFormatter setDateFormat:@"mm:ss"];
                dateFromString = [dateFormatter dateFromString:tempAuction.countdown];
            }
            NSString *tempDate = [dateFormatter stringFromDate:[dateFromString dateByAddingTimeInterval:-1.0]];
//            NSLog(@"tempDate:%@",tempDate);
            
            tempAuction.countdown = tempDate;
        }
    }
    for (ActivityCollectionViewCell *cell in [self.allActivityCollectionView visibleCells]) {
         NSIndexPath *indexPath = [self.allActivityCollectionView indexPathForCell:cell];
        if( [cell.lblCountDown.text isEqualToString:@"00:00:00"]) {
            [cell.lblCountDown setText:@"00:00:00"];
            currentPage = 0;
            arrActiveAuctions = [NSMutableArray array];
            
            [self getAuctions];
//            return;
        }

        if(arrActiveAuctions.count > 0) {
          [cell.lblCountDown setText:[[arrActiveAuctions objectAtIndex:indexPath.row] countdown]];
           // [self.allActivityCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
        
        
    }
  }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [_allActivitySegmentControl setItems:[NSArray arrayWithObjects://[[PPiFlatSegmentItem alloc] initWithTitle:@"ACTIVE" andIcon:nil],
                                          [[PPiFlatSegmentItem alloc] initWithTitle:@"UPCOMING AUCTION" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"MY BID" andIcon:nil], nil]];
    
    _allActivitySegmentControl.selectedColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    
    _allActivitySegmentControl.color = [UIColor whiteColor];
    _allActivitySegmentControl.selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14],
                                                 NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]};
    
    _allActivitySegmentControl.textAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14],
                                         NSForegroundColorAttributeName:[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0]};
    _allActivitySegmentControl.layer.cornerRadius = 5;
    _allActivitySegmentControl.clipsToBounds = YES;
    [_allActivitySegmentControl setSegmentAtIndex:0 enabled:YES];
    
    filter = filterTypeString(0);
    
    currentPage = 0;
    arrActiveAuctions = [NSMutableArray array];
    filterArrMyBid = [NSMutableArray array];
    arrUpcoming = [NSMutableArray array];

    if(_allActivitySegmentControl.selectedSegmentIndex == 0) {
        //activityType = @"";
        activityType = @"upcoming";
        [self getAuctions];
    }else if(_allActivitySegmentControl.selectedSegmentIndex == 1){
        activityType = @"";
         [self getAuctions];
    }else {
       activityType = @"upcoming";
         [self getAuctions];
        
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //    [self.tabBarController setTitle:@"ALL ACTIVITY"];
    //    [self.activityScroll setContentOffset:CGPointMake(self.activityScroll.frame.size.width, 0)];
    [self.tabBarController setTitle:@"ALL ACTIVITY"];
   
    rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter1"] style:UIBarButtonItemStylePlain target:self action:@selector(filterAllActivity:)];
    
    moreBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More_White"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked:)];

    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBarButton,rightBarButton,nil];

    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Home_White"] style:UIBarButtonItemStylePlain target:self action:@selector(homeBtnClicked:)];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = homeBarButton;

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItems = nil;
}

-(void)dealloc{
    [timer invalidate];
    timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)getAuctions {
    NSDate *startDate = [NSDate date];
    [[SharedAppDelegate pusherClient] bindToEventNamed:@"activity_event" handleWithBlock:^(PTPusherEvent *channelEvent) {
        // channelEvent.data is a NSDictianary of the JSON object received
        
        NSDictionary *eventData = [[NSDictionary alloc]initWithDictionary:channelEvent.data];
        NSLog(@"EventData:%@",eventData);
        for (Auction *tempAuction in arrActiveAuctions) {
            if ([tempAuction.auction_id isEqualToString:[eventData valueForKey:@"auction_id"]]) {
                tempAuction.bid_received = [NSString stringWithFormat:@"%@",[eventData valueForKey:@"bid_count"]];
                tempAuction.vehicle_price = [NSString stringWithFormat:@"%@",[eventData valueForKey:@"bid_amount"]];
                if([[eventData valueForKey:@"last_bidder_id"] isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
                    tempAuction.my_bid = [eventData valueForKey:@"bid_amount"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_allActivityCollectionView reloadData];
                    
                });
                
            }
        }
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,ACTIVITY];
//    NSDictionary *headers = [NSDictionary dictionaryWithObject:[WSLoading getCurrentUserDetailForKey:@"auth_key"] forKey:@"AUTH_KEY"];
    NSDictionary *params = @{@"dealer_country":[WSLoading getCurrentUserDetailForKey:@"dealer_country"],
                             @"offset":[NSNumber numberWithInt:currentPage],
                             @"filter":filterTypeString(self.filterType),
                             @"activity_type":activityType};
    
     NSLog(@"Params:%@",params);
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError *error;
        
        NSLog(@"%@",[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
        AllAuctions *allAuctions = [[AllAuctions alloc]initWithData:result error:&error];
        if(!error) {
            record = [allAuctions.per_page_records intValue];
            limit = [allAuctions.per_page_limit intValue];
            
            if([activityType isEqualToString:@"off"]) {
                
                [arrAuctions addObjectsFromArray:allAuctions.activity_auction];
                
            }else if([activityType isEqualToString:@""]) {
                NSDate *endDate = [NSDate date];
                timeInterval = [startDate timeIntervalSinceDate:endDate];
                NSLog(@"TimeInterval:%f",timeInterval);
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                
                for (Auction *tempAuction in allAuctions.activity_auction) {
                    NSDate *dateFromString = [dateFormatter dateFromString:tempAuction.countdown];
                    if (dateFromString == nil) {
                        [dateFormatter setDateFormat:@"mm:ss"];
                        dateFromString = [dateFormatter dateFromString:tempAuction.countdown];
                    }
                    NSString *tempDate = [dateFormatter stringFromDate:[dateFromString dateByAddingTimeInterval:timeInterval]];
                    tempAuction.countdown = tempDate;
                    
                    //tempAuction.my_bid =  myBidStr;
                }
                
                NSArray *filtered = [allAuctions.activity_auction filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(my_bid != %@)", @""]];
                
                
                 [arrActiveAuctions addObjectsFromArray:filtered];
                
                
//                if([ filterTypeString(self.filterType) isEqualToString: @"mybid"]){
//
//
//                    NSArray *filtered = [allAuctions.activity_auction filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(my_bid != %@)", @""]];
//
//                    NSLog(@"filteredData:%@",filtered);
//
//                  [filterArrMyBid addObjectsFromArray:filtered];
//
//
//
//                }else{
//
//                   [arrActiveAuctions addObjectsFromArray:allAuctions.activity_auction];
//                }
                
            }else {
               
                [arrUpcoming addObjectsFromArray:allAuctions.activity_auction];
            }
            
            
            if(arrUpcoming.count == 0 && _allActivitySegmentControl.selectedSegmentIndex == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"No upcoming auction found" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }else if(arrActiveAuctions.count == 0 && _allActivitySegmentControl.selectedSegmentIndex == 1) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"No my bid auction found" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                 [self presentViewController:alert animated:YES completion:nil];
            }
            
//            if(arrActiveAuctions.count == 0  && filterArrMyBid.count == 0  && _allActivitySegmentControl.selectedSegmentIndex == 0) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"No active auction found" preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//                [self presentViewController:alert animated:YES completion:nil];
//            }else if(arrAuctions.count == 0 && _allActivitySegmentControl.selectedSegmentIndex == 1) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"No auction found" preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//                [self presentViewController:alert animated:YES completion:nil];
//            }else if(arrUpcoming.count == 0 && _allActivitySegmentControl.selectedSegmentIndex == 2) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"No upcoming auction found" preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//                [self presentViewController:alert animated:YES completion:nil];
//            }

            if([activityType  isEqualToString: @"off"]) {
                [_tblOffAuction reloadData];
            }else  {
                [_allActivityCollectionView reloadData];
            }
                
            
        }
    }];
}


-(void)getFilteredActivity {
    currentPage = 0;
    if(_allActivitySegmentControl.selectedSegmentIndex == 0) {
        
//      if([ filterTypeString(self.filterType) isEqualToString: @"mybid"]){
//          filterArrMyBid = [NSMutableArray array];
//
//      }else{
//
//        arrActiveAuctions = [NSMutableArray array];
//
//      }
        
        arrUpcoming = [NSMutableArray array];
        
        
    }else if(_allActivitySegmentControl.selectedSegmentIndex == 1) {
        arrActiveAuctions = [NSMutableArray array];
    }else{
       arrUpcoming = [NSMutableArray array];
        
    }
    [self getAuctions];
}

-(void)refresh:(UIRefreshControl *)sender {
    [sender endRefreshing];
    currentPage = 0;
    if(_allActivitySegmentControl.selectedSegmentIndex == 0) {
        
         arrUpcoming = [NSMutableArray array];
        
//        if([ filterTypeString(self.filterType) isEqualToString: @"mybid"]){
//            filterArrMyBid = [NSMutableArray array];
//
//        }else{
//
//            arrActiveAuctions = [NSMutableArray array];
//
//        }
       // arrActiveAuctions = [NSMutableArray array];
    }else if(_allActivitySegmentControl.selectedSegmentIndex == 1) {
        arrActiveAuctions = [NSMutableArray array];
    }else{
        
        arrUpcoming = [NSMutableArray array];
        
    }
    [self getAuctions];

//    [_tblOffAuction reloadData];
}

-(void)moreBtnClicked:(id)sender {
    [myappDelegate moreBtnClicked:nil];
}

-(void)homeBtnClicked:(id)sender {
    [myappDelegate homeBtnClicked:nil];
}

-(void)filterAllActivity:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"All" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.filterType = AllActivity;
        [self getFilteredActivity];
        [_allActivityCollectionView reloadData];
        //        self.historyType = Won;
        //        [_tblHistory reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Selling" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.filterType = Selling;
        [self getFilteredActivity];
        [_allActivityCollectionView reloadData];
//        self.historyType = Won;
//        [_tblHistory reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Buying" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.filterType = Buying;
        [self getFilteredActivity];
        [_allActivityCollectionView reloadData];
//        self.historyType = Lost;
//        [_tblHistory reloadData];
    }]];
    
    
//    [alert addAction:[UIAlertAction actionWithTitle:@"My Bid" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.filterType = MyBid;
//        [self getFilteredActivity];
//        [_allActivityCollectionView reloadData];
//        //        self.historyType = Lost;
//        //        [_tblHistory reloadData];
//    }]];
//
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       // self.filterType = AllActivity;
//        [self getFilteredActivity];
//        [_allActivityCollectionView reloadData];
//        self.historyType = History;
//        [_tblHistory reloadData];
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

#pragma mark - CollectionView Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
if([activityType isEqualToString: @""]) {
    
    if([filterTypeString(self.filterType) isEqualToString: @"mybid"]){
        
          return filterArrMyBid.count;
        
    }else{
        
         return arrActiveAuctions.count;
    }

}else {
    
    return arrUpcoming.count;
    
   }
   
}

- (UILabel *)extracted:(ActivityCollectionViewCell *)cell {
    return cell.lblVehicleName;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
//    CGRect frame = cell.view.frame;
//    frame.size.height = 20;
//    cell.view.frame = frame;
    
    if(arrActiveAuctions.count > 0   && [activityType  isEqualToString: @""]) {
        
        
         if([ filterTypeString(self.filterType) isEqualToString: @"mybid"]){
             
             Auction *tempAuction = (Auction *)[filterArrMyBid objectAtIndex:indexPath.row];
             
             cell.postNowBtn.hidden = true;
             cell.lblBids.hidden = false;
             cell.lblPrice.hidden = false;
             cell.lblDistance.hidden = false;
             cell.lblCountDown.hidden = false;
             cell.editBtn.hidden = true;
             
             
             if([tempAuction.my_bid isEqualToString:tempAuction.vehicle_price]) {
                 [cell.lblBids setBackgroundColor:[UIColor colorWithRed:64/255.0 green:128/255.0 blue:0 alpha:1.0]];
             }else {
                 [cell.lblBids setBackgroundColor:[UIColor redColor]];
             }
             
             
             if([tempAuction.bid_received isEqualToString:@"0"]) {
                 [cell.lblBids setBackgroundColor:[UIColor grayColor]];
             }
             
             if([tempAuction.auction_dealer_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
                 [cell.lblBids setBackgroundColor:[UIColor grayColor]];
             }
             
             [cell.lblBids setText:tempAuction.bid_received];
             
             if(tempAuction.distance.length > 0) {
                 [cell.lblDistance setText:[NSString stringWithFormat:@"| %@ away",tempAuction.distance]];
             }
             if(tempAuction.vehicle_price == nil) {
                 [cell.lblPrice setText:[NSString stringWithFormat:@"$ 0"]];
             }else {
                 [cell.lblPrice setText:[NSString stringWithFormat:@"$ %@",tempAuction.vehicle_price]];
             }
             [[self extracted:cell] setText:[NSString stringWithFormat:@"%@ %@ %@",tempAuction.vehicle_year,tempAuction.vehicle_make,tempAuction.vehicle_model]];
             
             [cell.lblCountDown setText:tempAuction.countdown];
             
             
             NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?w=%d&h=%d",tempAuction.vehicle_images,(int)CGRectGetWidth(cell.imgCar.frame) * 3,(int)CGRectGetHeight(cell.imgCar.frame) * 3]];
             NSURLRequest *imgUrlRequest = [NSURLRequest requestWithURL:imgUrl];
             
             [cell.imgCar setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                 //            NSLog(@"Image Loaded");
                 //            [cell.imgCar setImage:[image imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
                 [cell.imgCar setImage:image];
                 
             }  failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                 NSLog(@"Error:%@",error.localizedDescription);
                 cell.imgCar = nil;
             }];
             
             if(indexPath.row == filterArrMyBid.count - 1 && [activityType isEqualToString:@""])
             {
                 currentPage = currentPage + limit;
                 if((!record<limit)) {
                     [self getAuctions];
                 }
             }
             
         }else{
             
             Auction *tempAuction = (Auction *)[arrActiveAuctions objectAtIndex:indexPath.row];
             
             cell.postNowBtn.hidden = true;
             cell.lblBids.hidden = false;
             cell.lblPrice.hidden = false;
             cell.lblDistance.hidden = false;
             cell.lblCountDown.hidden = false;
             cell.editBtn.hidden = true;
             
             
             if([tempAuction.my_bid isEqualToString:tempAuction.vehicle_price]) {
                 [cell.lblBids setBackgroundColor:[UIColor colorWithRed:64/255.0 green:128/255.0 blue:0 alpha:1.0]];
             }else {
                 [cell.lblBids setBackgroundColor:[UIColor redColor]];
             }
             
             
             if([tempAuction.bid_received isEqualToString:@"0"]) {
                 [cell.lblBids setBackgroundColor:[UIColor grayColor]];
             }
             
             if([tempAuction.auction_dealer_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
                 [cell.lblBids setBackgroundColor:[UIColor grayColor]];
             }
             
             [cell.lblBids setText:tempAuction.bid_received];
             
             if(tempAuction.distance.length > 0) {
                 [cell.lblDistance setText:[NSString stringWithFormat:@"| %@ away",tempAuction.distance]];
             }
             if(tempAuction.vehicle_price == nil) {
                 [cell.lblPrice setText:[NSString stringWithFormat:@"$ 0"]];
             }else {
                 [cell.lblPrice setText:[NSString stringWithFormat:@"$ %@",tempAuction.vehicle_price]];
             }
             [[self extracted:cell] setText:[NSString stringWithFormat:@"%@ %@ %@",tempAuction.vehicle_year,tempAuction.vehicle_make,tempAuction.vehicle_model]];
             
             [cell.lblCountDown setText:tempAuction.countdown];
             
             
             NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?w=%d&h=%d",tempAuction.vehicle_images,(int)CGRectGetWidth(cell.imgCar.frame) * 3,(int)CGRectGetHeight(cell.imgCar.frame) * 3]];
             NSURLRequest *imgUrlRequest = [NSURLRequest requestWithURL:imgUrl];
             
             [cell.imgCar setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                 //            NSLog(@"Image Loaded");
                 //            [cell.imgCar setImage:[image imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
                 [cell.imgCar setImage:image];
                 
             }  failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                 NSLog(@"Error:%@",error.localizedDescription);
                 cell.imgCar = nil;
             }];
             
             if(indexPath.row == arrActiveAuctions.count - 1 && [activityType isEqualToString:@""])
             {
                 currentPage = currentPage + limit;
                 if((!record<limit)) {
                     [self getAuctions];
                 }
             
             }
             
         }
    
 

       
    }else  if(arrUpcoming.count > 0 && [activityType  isEqualToString: @"upcoming"])  {
        
        Auction *tempAuction = (Auction *)[arrUpcoming objectAtIndex:indexPath.row];
        
         cell.postNowBtn.hidden = false;
         cell.editBtn.hidden = false;
        
         cell.lblBids.hidden = true;
         cell.lblPrice.hidden = true;
         cell.lblDistance.hidden = true;
         cell.lblCountDown.hidden = true;
        
        
    NSString *dmString = [tempAuction.created_date substringToIndex:[tempAuction.created_date length] - 3];
        
        
        [[self extracted:cell] setText:[NSString stringWithFormat:@"%@ @  %@",tempAuction.vehicle_make,dmString]];
        
        
       // [[self extracted:cell] setText:[NSString stringWithFormat:@"Scheduled for Auction on  %@",tempAuction.created_date]];

       // cell.lblVehicleName.textColor = [UIColor redColor];
        
        //if ([Login sharedInstance].dealer_id == tempAuction.auction_dealer_id) {
            if ([[Login sharedInstance].dealer_id isEqualToString:tempAuction.auction_dealer_id]) {

            [cell.postNowBtn setTitle:@"Launch" forState:UIControlStateNormal];
            cell.postNowBtn.tag = indexPath.row;
            [cell.postNowBtn addTarget:self action:@selector(postNowClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
                cell.editBtn.tag = indexPath.row;
                [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
          [cell.postNowBtn setTitle:@"View Detail" forState:UIControlStateNormal];
            cell.postNowBtn.tag = indexPath.row;
            [cell.postNowBtn addTarget:self action:@selector(postNowClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.editBtn.hidden = true;
//            CGRect frameimg = CGRectMake(60, 37, 100,30);
//            cell.postNowBtn.frame = frameimg;
            
        }
        
        NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?w=%d&h=%d",tempAuction.vehicle_images,(int)CGRectGetWidth(cell.imgCar.frame) * 3,(int)CGRectGetHeight(cell.imgCar.frame) * 3]];
        NSURLRequest *imgUrlRequest = [NSURLRequest requestWithURL:imgUrl];
        
        [cell.imgCar setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            //            NSLog(@"Image Loaded");
            //            [cell.imgCar setImage:[image imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
            [cell.imgCar setImage:image];
            
        }  failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error.localizedDescription);
            cell.imgCar = nil;
        }];
        
        if(indexPath.row == arrUpcoming.count - 1 && [activityType isEqualToString:@"upcoming"])
        {
            currentPage = currentPage + limit;
            if((!record<limit)) {
                [self getAuctions];
            }
            
        }
    }
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CGRectGetWidth(_allActivityCollectionView.frame)/2-1), (CGRectGetWidth(self.view.frame)/2-2));
}

#pragma mark - CollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     if([activityType isEqual: @""]) {
         
    if([ filterTypeString(self.filterType) isEqualToString: @"mybid"]){
        
        Auction *tempAuction = [filterArrMyBid objectAtIndex:indexPath.row];
        DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailViewController.currentAuction = tempAuction;
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        
    }else{
        
        Auction *tempAuction = [arrActiveAuctions objectAtIndex:indexPath.row];
        DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailViewController.currentAuction = tempAuction;
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    }

         
     }else{
         
         Auction *tempAuction = [arrUpcoming objectAtIndex:indexPath.row];
         DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
         detailViewController.currentAuction = tempAuction;
         [self.navigationController pushViewController:detailViewController animated:YES];
         
         
         
     }
}

#pragma mark - UITableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAuctions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuctionCell"];
    if(arrAuctions.count > 0) {
        Auction *tempAuction = [arrAuctions objectAtIndex:indexPath.row];
        
        [cell.lblExtColor setText:[NSString stringWithFormat:@"EXTERIOR: %@",tempAuction.vehicle_exterior_color].uppercaseString];
        [cell.lblIntColor setText:[NSString stringWithFormat:@"INTERIOR: %@",tempAuction.vehicle_interior_color].uppercaseString];
        [cell.lblTransmission setText:[NSString stringWithFormat:@"TRANSMISSION: %@",tempAuction.vehicle_transmission].uppercaseString];
        
        
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
            [cell.lblTransmission setTextColor:[UIColor blackColor]];
            [cell.lblCarName setTextColor:[UIColor blackColor]];
            cell.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
            [cell.lblDealerName setTextColor:[UIColor blackColor]];
            [cell.lblMileage setTextColor:[UIColor blackColor]];
            [cell.lblExtColor setTextColor:[UIColor blackColor]];
            [cell.lblIntColor setTextColor:[UIColor blackColor]];
            [cell.btnHistory setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
            
        }
        cell.btnHistory.tag = indexPath.row;
        [cell.btnHistory addTarget:self action:@selector(showHistory:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if([tempAuction.auction_dealer_id isEqualToString:[WSLoading getCurrentUserDetailForKey:@"dealer_id"]]) {
            [cell.btnSellThis setHidden:NO];
            [cell.btnParkThis setHidden:NO];
            cell.btnSellThis.tag = indexPath.row;
            [cell.btnSellThis addTarget:self action:@selector(sellThis:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnParkThis.tag = indexPath.row;
            [cell.btnParkThis addTarget:self action:@selector(parkThis:) forControlEvents:UIControlEventTouchUpInside];
            
            if(tempAuction.vehicle_price == nil) {
                [cell.btnSellThis setHidden:YES];
            } else {
                [cell.btnSellThis setHidden:NO];
            }
            
        }else {
            
            [cell.btnSellThis setHidden:YES];
            [cell.btnParkThis setHidden:YES];
            
            
        }
        
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

        
        [cell.lblCountdown setText:@"0:0:0"];
        [cell.lblBidReceived setText:tempAuction.bid_received];
        [cell.lblCarName setText:[NSString stringWithFormat:@"%@ %@ %@",tempAuction.vehicle_year,tempAuction.vehicle_make,tempAuction.vehicle_model]];
        [cell.lblDealerName setText:tempAuction.vehicle_dealer_id];
        if(tempAuction.distance.length > 0) {
            [cell.lblDistance setText:[NSString stringWithFormat:@"| %@ away",tempAuction.distance]];
        }
        [cell.lblMileage setText:[NSString stringWithFormat:@"MILEAGE: %@ %@",tempAuction.vehicle_mileage,tempAuction.mileage_type]];
        if(tempAuction.vehicle_price == nil) {
            [cell.lblPrice setText:[NSString stringWithFormat:@"$ 0"]];
        }else {
            [cell.lblPrice setText:[NSString stringWithFormat:@"$ %@",tempAuction.vehicle_price]];
        }
        
         NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?w=%d&h=%d",tempAuction.vehicle_images,(int)CGRectGetWidth(cell.imgCar.frame) * 3,(int)CGRectGetHeight(cell.imgCar.frame) * 3]];
        NSURLRequest *imgUrlRequest = [NSURLRequest requestWithURL:imgUrl];
        
        [cell.imgCar setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//            NSLog(@"Image Loaded");
//            [cell.imgCar setImage:[image imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
            [cell.imgCar setImage:image];
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error.localizedDescription);
            cell.imgCar = nil;
        }];

        imgUrlRequest = [NSURLRequest requestWithURL:tempAuction.flag_country];
        
        [cell.imgFlag setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//            NSLog(@"Image Loaded");
            [cell.imgFlag setImage:image];
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error.localizedDescription);
            cell.imgCar = nil;
        }];
        
        if(indexPath.row == arrAuctions.count - 1 && [activityType isEqualToString:@"off"])
        {
            currentPage = currentPage + limit;
            if((!record<limit)) {
                [self getAuctions];
            }
        }
    }
    return cell;
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if([[WSLoading getCurrentUserDetailForKey:@"dealer_type"] isEqualToString:@"dealer"] || [[WSLoading getCurrentUserDetailForKey:@"dealer_type"] isEqualToString:@"admin"]) {
//        return YES;
//    }else {
//        return NO;
//    }
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

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Auction *tempAuction = [arrAuctions objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailViewController.currentAuction = tempAuction;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UIButton Actions

- (IBAction)segmentValueChanged:(PPiFlatSegmentedControl *)sender {
    NSLog(@"Selected Index:%lu",(unsigned long)sender.selectedSegmentIndex);
    currentPage = 0;
    if(sender.selectedSegmentIndex == 0) {
        
        rightBarButton.enabled = true;
        rightBarButton.tintColor = [UIColor whiteColor];
      
        
        activityType = @"upcoming";
        
        [_allActivityScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        arrUpcoming = [NSMutableArray array];
        [self getAuctions];
//        activityType = @"";
//
//        [_allActivityScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        arrActiveAuctions = [NSMutableArray array];
//        [self getAuctions];
//        [_allActivityCollectionView reloadData];
   
    }else if(sender.selectedSegmentIndex == 1) {
        
        rightBarButton.enabled = false;
        rightBarButton.tintColor = [UIColor clearColor];
    
                activityType = @"";
        
                [_allActivityScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                arrActiveAuctions = [NSMutableArray array];
                [self getAuctions];
                [_allActivityCollectionView reloadData];
//        [_allActivityScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame),0) animated:YES];
//        activityType = @"off";
//
//        filter = @"";
////        if(!arrAuctions.count>0) {
//                arrAuctions = [NSMutableArray array];
//
//            [self getAuctions];
////        }
//        [_tblOffAuction reloadData];
        
    }else{
        
        activityType = @"upcoming";
        
        [_allActivityScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        arrUpcoming = [NSMutableArray array];
        [self getAuctions];
        
        
    }
}

-(void)editBtnClick:(UIButton *)sender {
    
     Auction *tempAuction = [arrUpcoming objectAtIndex:sender.tag];
    AddCarDetailViewController *addCarDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarDetailViewController"];
    addCarDetail.currentAuction = tempAuction;
    [self.navigationController pushViewController:addCarDetail animated:YES];
    
    
}

-(void)postNowClick:(UIButton *)sender {
    
     Auction *tempAuction = [arrUpcoming objectAtIndex:sender.tag];
    //if ([Login sharedInstance].dealer_id == tempAuction.auction_dealer_id){
    if ([[Login sharedInstance].dealer_id isEqualToString:tempAuction.auction_dealer_id]) {

    NSString *auction_id =  tempAuction.auction_id ;
    NSLog(@"auction_id:%@",auction_id);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            tempAuction.auction_id,@"auction_id",
                            nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,SCHEDULE_NOW];
    
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        
        NSLog(@"JSON:%@",json);
        if(!error) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"Your Vehicle has been Active successfully" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                currentPage = 0;
                arrUpcoming = [NSMutableArray array];
                [self getAuctions];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
    
    }else{
        
        //Auction *tempAuction = [arrUpcoming objectAtIndex:indexPath.row];
        DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailViewController.currentAuction = tempAuction;
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    }

}

-(void)sellThis:(UIButton *)sender {
    Auction *tempAuction = [arrAuctions objectAtIndex:sender.tag];
    NSString *message = [NSString stringWithFormat:@"Are you want to sell %@ %@ %@ on $%@ price?",tempAuction.vehicle_year,tempAuction.vehicle_make,tempAuction.vehicle_model,tempAuction.vehicle_price];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             //BUTTON OK CLICK EVENT
                             [self auctionParkSell:REALSELLAUCTION andAuction:tempAuction.auction_id baseURL:YES];

                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
   // [self auctionParkSell:SELLAUCTION andAuction:tempAuction.auction_id];

    
}

-(void)parkThis:(UIButton *)sender {
//    Auction *tempAuction = [arrAuctions objectAtIndex:sender.tag];
//    [self auctionParkSell:PARKAUCTION andAuction:tempAuction.auction_id];
    [self relaunchCar:sender.tag];
}
/*- (NSString *) createParamString:(NSDictionary *) params{
    
    NSString *result = @"";
    id key;
    NSEnumerator *enumerator = [params keyEnumerator];
    while (key = [enumerator nextObject]) {
        result = [result stringByAppendingFormat:@"%@=%@&", key, [params objectForKey:key]];
    }
    result = [result substringToIndex:[result length] - 1];
    return [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}*/

-(void)relaunchCar:(NSUInteger)indexRow {
    
    Auction *_currentAuction = [arrAuctions objectAtIndex:indexRow];
    AddCarDetailViewController *addCarDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarDetailViewController"];
    addCarDetail.currentAuction = _currentAuction;
    [self.navigationController pushViewController:addCarDetail animated:YES];
    
    /*
    
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"AUTH_KEY": [Login sharedInstance].auth_key,
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

    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSDate *endDate = [NSDate date];
        NSError *error;
        [VehicleDetails resetSharedInstance];
            VinDetail *vinDetail = [[VinDetail alloc]initWithData:result error:&error];
            if(!error) {
                if(vinDetail.error_message) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:vinDetail.error_message preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }else {
                    setObjectInUserDefaults(@"vin_id", vinDetail.vin);
                    AddCarDetailViewController *addCarDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarDetailViewController"];
                    addCarDetails.vinDetail = vinDetail;
                    addCarDetails.isFromDetails = YES;
                    [self.navigationController pushViewController:addCarDetails animated:YES];
                }
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        
    }];*/
}




-(void)auctionParkSell:(NSString *)type andAuction:(NSString *)auction  baseURL:(BOOL)isChnage{
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
        NSLog(@"%@",[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);

        if(!error) {
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:[json objectForKey:@"success_message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    currentPage = 0;
                    arrAuctions = [NSMutableArray array];
                    [self getAuctions];
                });
                
            }]];
            [self presentViewController:successAlert animated:YES completion:nil];
        } else {
            [WSLoading dismissLoading];
            //            [WSLoading showAlertWithTitle:@"Error" Message:json];
            NSString *message = [json objectForKey:@"error_message"];
            if ([message length]) {
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:[json objectForKey:@"error_message"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:successAlert animated:YES completion:nil];
            }
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
