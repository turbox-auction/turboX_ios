//
//  UtilityViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "UtilityViewController.h"
#import "UtilityCell.h"
#import "DocumentsViewController.h"
#import "FeedbackViewController.h"

@interface UtilityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrUtility;
}
@property (weak, nonatomic) IBOutlet UITableView *tblUtility;

@end

@implementation UtilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tabBarController setTitle:@"UTILITY"];
    arrUtility = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Utility" ofType:@"plist"]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
}

#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrUtility count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UtilityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UtilityCell"];
    [cell.lblUtility setText:[[[arrUtility objectAtIndex:indexPath.row] valueForKey:@"title"] uppercaseString]];
    [cell.imgUtility setImage:[UIImage imageNamed:[[arrUtility objectAtIndex:indexPath.row] valueForKey:@"image"]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            DocumentsViewController *documentsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DocumentsViewController"];
            [self.navigationController pushViewController:documentsVC animated:YES];
        }
            break;
        case 1:{
            
        }
            break;
        case 2: {
            FeedbackViewController *feedbackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        default:
            break;
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
