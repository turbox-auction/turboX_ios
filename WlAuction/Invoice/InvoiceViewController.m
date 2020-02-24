//
//  InvoiceViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "InvoiceViewController.h"
#import "InvoiceCell.h"
#import "WSLoading.h"
#import "AllInvoice.h"
#import "CarProofViewController.h"


@interface InvoiceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrInvoice;
}
@property (weak, nonatomic) IBOutlet UITableView *tblInvoice;

@end

@implementation InvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getInvoices];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.tabBarController setTitle:@"MY INVOICE"];
    
    
    // Add bar button items
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

#pragma mark - UITableView DataSourcef=
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrInvoice.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceCell"];
   
    Invoice *tempInvoice = [arrInvoice objectAtIndex:indexPath.row];
    [cell.lblCarName setText:[NSString stringWithFormat:@"%@ %@ %@",tempInvoice.vehicle_year,tempInvoice.vehicle_make,tempInvoice.vehicle_model]];
   // if([arrInvoice count] == 0) {
    [cell.lblDealer setText:[NSString stringWithFormat:@"Dealer:%@",((WinnerDetails *)[tempInvoice.winner_detail objectAtIndex:0]).dealership_name]];
    //}
    [cell.lblInvoiceIndex setText:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        
    
    return cell;
 }




#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Invoice *tempInvoice = [arrInvoice objectAtIndex:indexPath.row];
    CarProofViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"CarProofViewController"];
    webView.urlString = tempInvoice.invoice;
    webView.mainTitle = @"Invoice";
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - Custom Methods

-(void)getInvoices {
    NSDictionary *headers = [NSDictionary dictionaryWithObject:[WSLoading getCurrentUserDetailForKey:@"auth_key"] forKey:@"AUTH-KEY"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,INVOICES];
    
    [WSLoading getResponseWithParameters:nil Url:urlString Headers:headers CompletionBlock:^(id result) {
        NSError *error;
        AllInvoice *allInvoices = [[AllInvoice alloc]initWithData:result error:&error];
        arrInvoice = allInvoices.invoices;
        NSLog(@"AllInvoice:%@",allInvoices);
        [_tblInvoice reloadData];
    }];
}

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
