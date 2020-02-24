//
//  DocumentsViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 09/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "DocumentsViewController.h"
#import "DocumentsCell.h"
#import "WSLoading.h"
#import "DocumentModel.h"
#import "CarProofViewController.h"

@interface DocumentsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    DocumentModel *documents;
}
@property (weak, nonatomic) IBOutlet UITableView *tblDocuments;

@end

@implementation DocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDocuments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tabBarController setTitle:@"DOCUMENTS"];
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

#pragma mark - Custom Methods

-(void)getDocuments {
     NSDictionary *headers = [NSDictionary dictionaryWithObject:[WSLoading getCurrentUserDetailForKey:@"auth_key"] forKey:@"AUTH-KEY"];
    [WSLoading getResponseWithParameters:nil Url:[NSString stringWithFormat:@"%@%@",BaseURL,DOCUMENTS] Headers:headers  CompletionBlock:^(id result) {
        
        documents = [[DocumentModel alloc]initWithData:result error:nil];
        [_tblDocuments reloadData];
        
    }];
}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentsCell"];
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:198/255.0 green:54/255.0 blue:46/255.0 alpha:1];
    cell.selectedBackgroundView = myBackView;

    switch (indexPath.row) {
        case 0:
            [cell.lblDocumentTitle setText:@"Turbox-Arbitration Form"];
            break;
        case 1:
            [cell.lblDocumentTitle setText:@"Turbox-Arbitration Policy"];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarProofViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"CarProofViewController"];
    switch (indexPath.row) {
        case 0:
            view.mainTitle = @"Turbox-Arbitration Form";
            view.urlString = documents.doc_form;
            break;
        case 1:
            view.mainTitle = @"Turbox-Arbitration Policy";
            view.urlString = documents.doc_policy;
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:view animated:YES];
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
