//
//  WonViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "WonViewController.h"
#import "InventoryCell.h"
#import "UIImage+Blur.h"

@interface WonViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblWon;

@end

@implementation WonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblWon.estimatedRowHeight = 180;
    _tblWon.rowHeight = UITableViewAutomaticDimension;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tabBarController setTitle:@"WON"];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
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

#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InventoryCell"];
    
    UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"car%ld",indexPath.row + 1]];
    
    //    [cell.imgCar setImage:[tempImage imageByScalingAndCroppingForSize:cell.imgCar.frame.size]];
    [cell.imgCar setImage:tempImage];
    
    [cell.imgBackground setImage:[tempImage blurredImageWithRadius:2.0 iterations:10 tintColor:[UIColor clearColor]]];
    [cell.imgBackground setAlpha:0.5];
    
    
    return cell;
}

#pragma mark - Custom Methods

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
