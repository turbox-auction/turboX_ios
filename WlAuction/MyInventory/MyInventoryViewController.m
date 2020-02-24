//
//  MyInventoryViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 08/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "MyInventoryViewController.h"
#import "InventoryCell.h"
#import "UIImage+Blur.h"
#import "UIImage+Resize.h"
#import "DetailViewController.h"
#import "WSLoading.h"
#import "AllAuctions.h"
#import "UIImageView+AFNetworking.h"
#import "PPiFlatSegmentedControl.h"
#import "AddCarDetailViewController.h"
#include "Pusher.h"

@interface MyInventoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrAuctions, *parkArr;
    int record,limit,currentPage;
    NSString *carType, *filterType;
    
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITableView *tblInventory;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *carTypeSegment;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *allActivitySegmentControl;

@end

@implementation MyInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblInventory.estimatedRowHeight = 180;
    _tblInventory.rowHeight = UITableViewAutomaticDimension;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_tblInventory addSubview:refreshControl];
    currentPage = 0;
    carType = @"used";
    arrAuctions = [NSMutableArray array];
    parkArr = [NSMutableArray array];
 
   // filterType = @"myinventory";
   //[self getMyInventory];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [_carTypeSegment setItems:[NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"Used Car" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"New Car" andIcon:nil], nil]];
    
    _carTypeSegment.selectedColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    _carTypeSegment.color = [UIColor whiteColor];
    _carTypeSegment.selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14],
                                                          NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:198/255.0 blue:19/255.0 alpha:1.0]};
    
    _carTypeSegment.textAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14],
                                                  NSForegroundColorAttributeName:[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0]};
    _carTypeSegment.layer.cornerRadius = 5;
    _carTypeSegment.clipsToBounds = YES;
    [_carTypeSegment setSegmentAtIndex:0 enabled:YES];
    
    [_allActivitySegmentControl setItems:[NSArray arrayWithObjects:[[PPiFlatSegmentItem alloc] initWithTitle:@"MY INVENTORY" andIcon:nil],[[PPiFlatSegmentItem alloc] initWithTitle:@"PARK" andIcon:nil], nil]];
    
    _allActivitySegmentControl.selectedColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    _allActivitySegmentControl.color = [UIColor whiteColor];
    _allActivitySegmentControl.selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14],
                                                          NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]};
    
    _allActivitySegmentControl.textAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14],
                                                  NSForegroundColorAttributeName:[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0]};
    _allActivitySegmentControl.layer.cornerRadius = 5;
    _allActivitySegmentControl.clipsToBounds = YES;
    [_allActivitySegmentControl setSegmentAtIndex:0 enabled:YES];
    
 
    
   currentPage = 0;
    arrAuctions = [NSMutableArray array];
     parkArr = [NSMutableArray array];
    
    if(_allActivitySegmentControl.selectedSegmentIndex == 0) {
        filterType = @"myinventory";
       [self getMyInventory];
    }else {
        filterType = @"park";
        [self getMyInventory];
    }

    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tabBarController setTitle:@"MY INVENTORY"];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
//    
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(loadAddCarPhotos:)];
//    
//    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButton;
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
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

- (IBAction)segmentValueFilterChanged:(PPiFlatSegmentedControl *)sender {
    NSLog(@"Selected Index:%lu",(unsigned long)sender.selectedSegmentIndex);
    currentPage = 0;
    if(sender.selectedSegmentIndex == 0) {
        filterType = @"myinventory";
        arrAuctions = [NSMutableArray array];
        [self getMyInventory];
      
    }else  {
        
        filterType = @"park";
        parkArr = [NSMutableArray array];
        [self getMyInventory];
       
        
    }
   [_tblInventory reloadData];
    
}




#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([filterType  isEqualToString: @"myinventory"]){
     return arrAuctions.count;
        
    }else {
        
        return parkArr.count;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InventoryCell"];
    
    if(arrAuctions.count > 0 && [filterType  isEqualToString: @"myinventory"])   {
        
        Auction *tempAuction = [arrAuctions objectAtIndex:indexPath.row];
        
        [cell.lblBidReceived setText:tempAuction.bid_received];
        [cell.lblCarName setText:[NSString stringWithFormat:@"%@ %@ %@",tempAuction.vehicle_year,tempAuction.vehicle_make,tempAuction.vehicle_model]];
        [cell.lblDealerName setText:tempAuction.vehicle_dealer_id];
        [cell.lblDistance setText:[NSString stringWithFormat:@"%@ away",tempAuction.distance]];
        [cell.lblMileage setText:[NSString stringWithFormat:@"MILEAGE: %@ %@",tempAuction.vehicle_mileage,tempAuction.mileage_type]];
        [cell.lblPrice setText:[NSString stringWithFormat:@"$ %@",tempAuction.vehicle_price]];
        
        [cell.lblAuctionState setText:[WSLoading convertToStringAuctionStatus:tempAuction.auction_status]];
        [cell.lblCountdown setText:tempAuction.countdown];
         NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?w=%d&h=%d",tempAuction.vehicle_images,(int)CGRectGetWidth(cell.imgCar.frame) * 3,(int)CGRectGetHeight(cell.imgCar.frame) * 3]];
        NSURLRequest *imgUrlRequest = [NSURLRequest requestWithURL:imgUrl];
        
        [cell.imgCar setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
//            [cell.imgCar setImage:[image imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
            [cell.imgCar setImage:image];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error.localizedDescription);
            cell.imgCar = nil;
        }];

        [cell.lblExtColor setText:[NSString stringWithFormat:@"EXTERIOR: %@",tempAuction.vehicle_exterior_color].uppercaseString];
        [cell.lblIntColor setText:[NSString stringWithFormat:@"INTERIOR: %@",tempAuction.vehicle_interior_color].uppercaseString];
        [cell.lblTransmission setText:[NSString stringWithFormat:@"TRANSMISSION: %@",tempAuction.vehicle_transmission].uppercaseString];
        
        
        cell.btnAuction.tag = indexPath.row;
        [cell.btnAuction addTarget:self action:@selector(addToAuction:) forControlEvents:UIControlEventTouchUpInside];
       
       [cell.btnAuction setTitle:@"Add to Auction" forState:UIControlStateNormal];
    
        cell.editBtnAuction.hidden = true;
        
        
        if(indexPath.row % 2) {
            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            
            cell.btnAuction.backgroundColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1.0];
            cell.btnAuction.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            [cell.lblTransmission setTextColor:[UIColor blackColor]];
            [cell.lblMileage setTextColor:[UIColor blackColor]];
            [cell.lblExtColor setTextColor:[UIColor blackColor]];
            [cell.lblIntColor setTextColor:[UIColor blackColor]];
             [cell.btnHistory setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
              cell.btnAuction.titleLabel.text = @"Add to Auction";
            [cell.btnAuction setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
            
            cell.btnAuction.backgroundColor = [UIColor colorWithRed:230/255.0 green:0/255.0 blue:29/255.0 alpha:1.0];
             [cell.btnAuction setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            [cell.lblTransmission setTextColor:[UIColor blackColor]];
            [cell.lblMileage setTextColor:[UIColor blackColor]];
            [cell.lblExtColor setTextColor:[UIColor blackColor]];
            [cell.lblIntColor setTextColor:[UIColor blackColor]];
            [cell.btnHistory setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
             cell.btnAuction.titleLabel.text = @"Add to Auction";
        }
        
        
        if(indexPath.row == arrAuctions.count - 1 && [filterType isEqualToString:@"myinventory"])
        {
            currentPage = currentPage + limit;
            if(!record<limit) {
                [self getMyInventory];
            }
            
        }
    }else{
        
        if(parkArr.count > 0 && [filterType  isEqualToString : @"park"])   {
            Auction *tempAuction = [parkArr objectAtIndex:indexPath.row];
            
            [cell.lblBidReceived setText:tempAuction.bid_received];
            [cell.lblCarName setText:[NSString stringWithFormat:@"%@ %@ %@",tempAuction.vehicle_year,tempAuction.vehicle_make,tempAuction.vehicle_model]];
            [cell.lblDealerName setText:tempAuction.vehicle_dealer_id];
            [cell.lblDistance setText:[NSString stringWithFormat:@"%@ away",tempAuction.distance]];
            [cell.lblMileage setText:[NSString stringWithFormat:@"MILEAGE: %@ %@",tempAuction.vehicle_mileage,tempAuction.mileage_type]];
            [cell.lblPrice setText:[NSString stringWithFormat:@"$ %@",tempAuction.vehicle_price]];
            
            [cell.lblAuctionState setText:[WSLoading convertToStringAuctionStatus:tempAuction.auction_status]];
            [cell.lblCountdown setText:tempAuction.countdown];
            NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?w=%d&h=%d",tempAuction.vehicle_images,(int)CGRectGetWidth(cell.imgCar.frame) * 3,(int)CGRectGetHeight(cell.imgCar.frame) * 3]];
            NSURLRequest *imgUrlRequest = [NSURLRequest requestWithURL:imgUrl];
            
            [cell.imgCar setImageWithURLRequest:imgUrlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                
                //            [cell.imgCar setImage:[image imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
                [cell.imgCar setImage:image];
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"Error:%@",error.localizedDescription);
                cell.imgCar = nil;
            }];
            
            [cell.lblExtColor setText:[NSString stringWithFormat:@"EXTERIOR: %@",tempAuction.vehicle_exterior_color].uppercaseString];
            [cell.lblIntColor setText:[NSString stringWithFormat:@"INTERIOR: %@",tempAuction.vehicle_interior_color].uppercaseString];
            [cell.lblTransmission setText:[NSString stringWithFormat:@"TRANSMISSION: %@",tempAuction.vehicle_transmission].uppercaseString];
            
            cell.editBtnAuction.hidden = false;
            cell.editBtnAuction.tag = indexPath.row;
            [cell.editBtnAuction addTarget:self action:@selector(editToAuction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.editBtnAuction setTitle:@"Edit" forState:UIControlStateNormal];
            //cell.editBtnAuction.frame = CGRectMake(100, 124, 80, 30);
           
            
            cell.btnAuction.tag = indexPath.row;
            [cell.btnAuction addTarget:self action:@selector(addToAuction:) forControlEvents:UIControlEventTouchUpInside];
             [cell.btnAuction setTitle:@"Launch" forState:UIControlStateNormal];
             //cell.btnAuction.frame = CGRectMake(10, 124, 80, 30);
           
            
            if(indexPath.row % 2) {
                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                
                cell.btnAuction.backgroundColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1.0];
                cell.btnAuction.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                
                cell.editBtnAuction.backgroundColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1.0];
                cell.editBtnAuction.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                
                
                [cell.lblTransmission setTextColor:[UIColor blackColor]];
                [cell.lblMileage setTextColor:[UIColor blackColor]];
                [cell.lblExtColor setTextColor:[UIColor blackColor]];
                [cell.lblIntColor setTextColor:[UIColor blackColor]];
                [cell.btnHistory setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
                
                [cell.btnAuction setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                 cell.btnAuction.titleLabel.text = @"Launch";
                
            }else{
                cell.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
                
                cell.btnAuction.backgroundColor = [UIColor colorWithRed:230/255.0 green:0/255.0 blue:29/255.0 alpha:1.0];
                [cell.btnAuction setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                cell.editBtnAuction.backgroundColor = [UIColor colorWithRed:230/255.0 green:0/255.0 blue:29/255.0 alpha:1.0];
                [cell.editBtnAuction setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                [cell.lblTransmission setTextColor:[UIColor blackColor]];
                [cell.lblMileage setTextColor:[UIColor blackColor]];
                [cell.lblExtColor setTextColor:[UIColor blackColor]];
                [cell.lblIntColor setTextColor:[UIColor blackColor]];
                [cell.btnHistory setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
                cell.btnAuction.titleLabel.text = @"Launch";
              
                
            }
            
            
            if(indexPath.row == parkArr.count - 1 && [filterType isEqualToString:@"park"])
            {
                currentPage = currentPage + limit;
                if(!record<limit) {
                    [self getMyInventory];
                }
                
            }
        
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([filterType  isEqual: @"myinventory"]){
    Auction *tempAuction = [arrAuctions objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailViewController.currentAuction = tempAuction;
    [self.navigationController pushViewController:detailViewController animated:YES];
          
      }else{
          
          Auction *tempAuction = [parkArr objectAtIndex:indexPath.row];
          DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
          detailViewController.currentAuction = tempAuction;
          [self.navigationController pushViewController:detailViewController animated:YES];
          
      }
}

#pragma mark - Custom Methods

-(void)editToAuction:(UIButton *)sender {
    
    AddCarDetailViewController *addCarDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarDetailViewController"];
    addCarDetail.currentAuction = [parkArr objectAtIndex:sender.tag];
    [self.navigationController pushViewController:addCarDetail animated:YES];
    
    
 }

-(void)addToAuction:(UIButton *)sender {
    
    if ([filterType  isEqual: @"myinventory"]){
        
    AddCarDetailViewController *addCarDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarDetailViewController"];
    addCarDetail.currentAuction = [arrAuctions objectAtIndex:sender.tag];
    [self.navigationController pushViewController:addCarDetail animated:YES];
        
        
        
    }else if ([filterType  isEqual: @"park"]){
        
        Auction *tempAuction = [parkArr objectAtIndex:sender.tag];
        NSString *auction_id =  tempAuction.auction_id ;
        NSLog(@"auction_id:%@",auction_id);
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                tempAuction.auction_id,@"auction_id",
                                nil];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,SCHEDULE_NOW];
        
        
        [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
            [WSLoading dismissLoading];
            NSError* error;
            NSString *json = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
          
            NSLog(@"JSON:%@",json);
            
            if(!error) {
               
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"Your Vehicle has been Launch successfully" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                      currentPage = 0;
                     parkArr = [NSMutableArray array];
                    [self getMyInventory];
                    
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }];
        
        
    }
}

-(void)getMyInventory {

    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,MY_LISTING];

    NSDictionary *params = @{@"dealer_country":[WSLoading getCurrentUserDetailForKey:@"dealer_country"],
                             @"offset":[NSNumber numberWithInt:currentPage],
                             @"filter":filterType,
                             @"car_type":@"used",
                             };
    
    NSLog(@"Params:%@",params);
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError *error;
        AllAuctions *allAuctions = [[AllAuctions alloc]initWithData:result error:&error];
        if(!error) {
            record = [allAuctions.per_page_records intValue];
            limit = [allAuctions.per_page_limit intValue];
            
            if([filterType isEqualToString:@"myinventory"]) {
                
                [arrAuctions addObjectsFromArray:allAuctions.activity_auction];
                
            }else  if([filterType isEqualToString:@"park"]){
                
                 [parkArr addObjectsFromArray:allAuctions.activity_auction];
                
            }
            
            
            if(arrAuctions.count == 0 && _allActivitySegmentControl.selectedSegmentIndex == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"my inventory auction not found" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }else if(parkArr.count == 0 && _allActivitySegmentControl.selectedSegmentIndex == 1){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TurboX" message:@"park auction not found" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            
           
                [_tblInventory reloadData];
            
            
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_tblInventory reloadData];
//            });
//            [_tblInventory reloadData];
        }else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }];
}

-(void)refresh:(id)sender {
    [sender endRefreshing];
    currentPage = 0;
    if(_allActivitySegmentControl.selectedSegmentIndex == 0) {
        arrAuctions = [NSMutableArray array];
        
    }else if(_allActivitySegmentControl.selectedSegmentIndex == 1){
       
     parkArr = [NSMutableArray array];
        
    }
   [self getMyInventory];

}

-(void)loadAddCarPhotos:(id)sender {
//    AddCarPhotosViewController *addCarPhotos = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarPhotosViewController"];
//    [self.navigationController pushViewController:addCarPhotos animated:YES];
}

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentValueChanged:(PPiFlatSegmentedControl *)sender {
    currentPage = 0;
    
    NSLog(@"Selected Index:%lu",(unsigned long)sender.selectedSegmentIndex);
    if(sender.selectedSegmentIndex == 0) {
        carType = @"used";
        [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setEnabled:YES];
        arrAuctions = [NSMutableArray array];
        parkArr = [NSMutableArray array];
        [self getMyInventory];
//        [_tblInventory reloadData];
    }else {
        carType = @"new";
        [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setEnabled:NO];
        
        arrAuctions = [NSMutableArray array];
        parkArr = [NSMutableArray array];
        [self getMyInventory];
        //        }
//        [_tblInventory reloadData];
    }
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
