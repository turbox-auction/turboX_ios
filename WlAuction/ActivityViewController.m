//
//  ActivityViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 02/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityViewCell.h"
#import "InventoryCell.h"
#import "UIImage+Blur.h"
#import "DetailViewController.h"
#import "WonViewController.h"
#import "SellViewController.h"
#import "BuylostViewController.h"
#import "WonCell.h"
#import "AppDelegate.h"

typedef enum {
    History = 0,
    Won,
    Lost,
    Sold,
    Removed
}HistoryType;

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, ActivityCellDelegate>
{
    NSMutableArray *arrCollapsed;
    
    NSMutableArray *arrAllActivity;
}
@property (weak, nonatomic) IBOutlet UITableView *tblActivity;
@property (weak, nonatomic) IBOutlet UITableView *tblBid;
@property (weak, nonatomic) IBOutlet UITableView *tblHistory;
@property (weak, nonatomic) IBOutlet UIScrollView *activityScroll;

@property (nonatomic, assign) HistoryType historyType;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrCollapsed = [NSMutableArray array];
    _tblActivity.estimatedRowHeight = 485;
    _tblActivity.rowHeight = UITableViewAutomaticDimension;
    
    _tblBid.estimatedRowHeight = 485;
    _tblBid.rowHeight = UITableViewAutomaticDimension;
    
    _tblHistory.estimatedRowHeight = 485;
    _tblHistory.rowHeight = UITableViewAutomaticDimension;
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resizeTableView:) name:@"ResizeTableView" object:nil];
    
    arrAllActivity = [[NSMutableArray alloc] initWithObjects:@{},@{},@{},nil];
    
    
    UISwipeGestureRecognizer *recognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//    recognizer.delaysTouchesBegan = TRUE;
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [_activityScroll addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_activityScroll addGestureRecognizer:recognizer];
    [_activityScroll delaysContentTouches];
    
    self.historyType = History;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
//    [self.tabBarController setTitle:@"ALL ACTIVITY"];
//    [self.activityScroll setContentOffset:CGPointMake(self.activityScroll.frame.size.width, 0)];
    
    CGFloat pageIndex = _activityScroll.contentOffset.x / CGRectGetWidth(_activityScroll.frame);
    switch ((int)pageIndex) {
        case 0:
            [self.tabBarController setTitle:@"ALL ACTIVITY"];
            self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
            break;
        case 1:
            [self.tabBarController setTitle:@"MY BIDS"];
            self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
            break;
        case 2:{
            UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter1"] style:UIBarButtonItemStylePlain target:self action:@selector(filterHistory:)];
             UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More_White"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked:)];
            self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBarButton,rightBarButton,nil];

            [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
            
            UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Home_White"] style:UIBarButtonItemStylePlain target:self action:@selector(homeBtnClicked:)];
            self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = homeBarButton;

            
            [self.tabBarController setTitle:@"HISTORY"];
        }
            break;
            
        default:
            break;
    }

    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipe {
    if(swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if(self.activityScroll.contentOffset.x - CGRectGetWidth(self.activityScroll.frame) >= 0){
            [UIView animateWithDuration:0.3 animations:^{
                [self.activityScroll setContentOffset:CGPointMake(self.activityScroll.contentOffset.x - CGRectGetWidth(_activityScroll.frame), 0)];
            }];
        }

    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(self.activityScroll.contentOffset.x + CGRectGetWidth(self.activityScroll.frame) < CGRectGetWidth(self.activityScroll.frame) * 3){
            [UIView animateWithDuration:0.3 animations:^{
                [self.activityScroll setContentOffset:CGPointMake(self.activityScroll.contentOffset.x + CGRectGetWidth(_activityScroll.frame), 0)];
            }];
        }
    }
    
    CGFloat pageIndex = _activityScroll.contentOffset.x / CGRectGetWidth(_activityScroll.frame);
    switch ((int)pageIndex) {
        case 0:
            [self.tabBarController setTitle:@"ALL ACTIVITY"];
            self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
            break;
        case 1:
            [self.tabBarController setTitle:@"MY BIDS"];
            self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
            break;
        case 2:{
            UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter1"] style:UIBarButtonItemStylePlain target:self action:@selector(filterHistory:)];
            
            UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More_White"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked:)];
            
            self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBarButton,rightBarButton,nil];
            [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
            UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Home_White"] style:UIBarButtonItemStylePlain target:self action:@selector(homeBtnClicked:)];
            self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = homeBarButton;


            [self.tabBarController setTitle:@"HISTORY"];
        }
            break;
            
        default:
            break;
    }
}

-(void)placeBid:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Place your bid" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)moreBtnClicked:(id)sender {
    [myappDelegate moreBtnClicked:nil];
}

-(void)homeBtnClicked:(id)sender {
    [myappDelegate homeBtnClicked:nil];
}
-(void)filterHistory:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Won" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.historyType = Won;
        [_tblHistory reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Lost" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.historyType = Lost;
        [_tblHistory reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Sold" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.historyType = Sold;
        [_tblHistory reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Removed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.historyType = Removed;
        [_tblHistory reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.historyType = History;
        [_tblHistory reloadData];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAllActivity.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _tblHistory) {
        if (self.historyType == History) {
            InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InventoryCell"];
            UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"car%ld",indexPath.row + 1]];
            
            //    [cell.imgCar setImage:[tempImage imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
            [cell.imgCar setImage:tempImage];
            
            [cell.imgBackground setImage:[tempImage blurredImageWithRadius:2.0 iterations:10 tintColor:[UIColor clearColor]]];
            [cell.imgBackground setAlpha:0.5];
            return cell;
        }else if (self.historyType == Won) {
            InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WonCell"];
            UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"car%ld",indexPath.row + 1]];
            
//                [cell.imgCar setImage:[tempImage imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
            [cell.imgCar setImage:tempImage];
            
            [cell.imgBackground setImage:[tempImage blurredImageWithRadius:2.0 iterations:10 tintColor:[UIColor clearColor]]];
            [cell.imgBackground setAlpha:0.5];
            return cell;

        }else if (self.historyType == Lost) {
            InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LostCell"];
            UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"car%ld",indexPath.row + 1]];
            
            //    [cell.imgCar setImage:[tempImage imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
            [cell.imgCar setImage:tempImage];
            
            [cell.imgBackground setImage:[tempImage blurredImageWithRadius:2.0 iterations:10 tintColor:[UIColor clearColor]]];
            [cell.imgBackground setAlpha:0.5];
            return cell;

        }else if (self.historyType == Sold) {
            InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoldCell"];
            UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"car%ld",indexPath.row + 1]];
            
            //    [cell.imgCar setImage:[tempImage imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
            [cell.imgCar setImage:tempImage];
            
            [cell.imgBackground setImage:[tempImage blurredImageWithRadius:2.0 iterations:10 tintColor:[UIColor clearColor]]];
            [cell.imgBackground setAlpha:0.5];
            return cell;

        }else {
            InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemovedCell"];
            UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"car%ld",indexPath.row + 1]];
            
            //    [cell.imgCar setImage:[tempImage imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
            [cell.imgCar setImage:tempImage];
            
            [cell.imgBackground setImage:[tempImage blurredImageWithRadius:2.0 iterations:10 tintColor:[UIColor clearColor]]];
            [cell.imgBackground setAlpha:0.5];
            return cell;

        }

        
    }
    else if(tableView == _tblActivity) {
        ActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
        [cell.btnPlaceBid addTarget:self action:@selector(placeBid:) forControlEvents:UIControlEventTouchUpInside];
        cell.superIndex = indexPath.row;
        [cell setDelegate:self];
        return cell;
    } else {
        ActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BidCell"];
        cell.superIndex = indexPath.row;
        [cell.btnPlaceBid addTarget:self action:@selector(placeBid:) forControlEvents:UIControlEventTouchUpInside];
        [cell setDelegate:self];
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [self.navigationController pushViewController:detailViewController animated:YES];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


#pragma mark - ActivityCell delegate
-(void)activityCellExpanded:(NSInteger )index;{
    [self.tblActivity reloadData];
    [self.tblBid reloadData];
}



@end
