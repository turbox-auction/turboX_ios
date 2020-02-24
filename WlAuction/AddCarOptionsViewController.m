//
//  AddCarOptionsViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 05/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "AddCarOptionsViewController.h"
#import "CustomSectionHeaderCell.h"
#import "AddCarPhotosViewController.h"
#import "OptionsCell.h"
#import "WSLoading.h"
#import "AFNetworking.h"

@interface AddCarOptionsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrCollapsed,*arrSelectedIndex;
    NSArray *arrHeaderTitle,*arrOptions;
}
@property (weak, nonatomic) IBOutlet UITableView *tblCarOptions;

@end

@implementation AddCarOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrHeaderTitle = [NSArray arrayWithObjects:@"SAFETY",@"WINDOWS",@"COMFORT", nil];
    arrCollapsed = [NSMutableArray array];
    arrSelectedIndex = [NSMutableArray array];
    
//    if(_options.count > 0) {
//        [self setCarOptions];
//    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tabBarController setTitle:@"SELL DETAILS"];
    arrOptions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Options" ofType:@"plist"]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"true_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(saveOptionalFeatures)];
    
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButton;
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [arrOptions count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[arrOptions objectAtIndex:section] objectForKey:@"options"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsCell"];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    [cell.lblTitle setText:[[[[arrOptions objectAtIndex:indexPath.section] objectForKey:@"options"] objectAtIndex:indexPath.row] uppercaseString]];
    if([arrSelectedIndex containsObject:indexPath]) {
//        [cell.imageView setImage:[UIImage imageNamed:@"checked"]];
        [cell.imgCheck setHighlighted:YES];
        
    }else {
//        [cell.imageView setImage:[UIImage imageNamed:@"unchecked"]];
        [cell.imgCheck setHighlighted:NO];
    }
    
    if([_options containsObject:[cell.lblTitle.text capitalizedString]]) {
        [cell.imgCheck setHighlighted:YES];
        [arrSelectedIndex addObject:indexPath];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    CustomSectionHeaderCell *sectionHeader = [tableView dequeueReusableCellWithIdentifier:@"SectionHeader"];
    [sectionHeader.lblHeaderTitle setText:[[[arrOptions objectAtIndex:section] valueForKey:@"header"] uppercaseString]];
    sectionHeader.btnHeader.tag = section;
    [sectionHeader.btnHeader addTarget:self action:@selector(expandHeader:) forControlEvents:UIControlEventTouchUpInside];
    if([arrCollapsed containsObject:cellIndexPath]) {
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arrCollapsed containsObject:indexPath])
    {
        return 0;
    }
    else
    {
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OptionsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if([_options containsObject:[cell.lblTitle.text capitalizedString]]) {
//        [cell.imgCheck setHighlighted:NO];
//        [arrSelectedIndex removeObject:indexPath];
//    }else {
//        [cell.imgCheck setHighlighted:YES];
//        [arrSelectedIndex addObject:indexPath];
//    }
    
    if (![arrSelectedIndex containsObject:indexPath]) {
        [arrSelectedIndex addObject:indexPath];
    }else {
        [arrSelectedIndex removeObject:indexPath];
        [_options removeObject:[cell.lblTitle.text capitalizedString]];
        
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([arrSelectedIndex containsObject:indexPath]) {
        [arrSelectedIndex removeObject:indexPath];
        
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Custom Methods
//-(void)setCarOptions {
//    for (NSString *temp in _options) {
//        if (temp isEqualToString:<#(nonnull NSString *)#>) {
//            <#statements#>
//        }
//    }
//}

-(void)expandHeader:(UIButton *)sender {
    sender.selected=!sender.selected;

    for (int i=0; i<[[[arrOptions objectAtIndex:sender.tag]objectForKey:@"options"] count]; i++) {
        NSIndexPath *temp = [NSIndexPath indexPathForRow:i inSection:sender.tag];
        if([arrCollapsed containsObject:temp]) {
            [arrCollapsed removeObject:temp];
        }
        else {
            [arrCollapsed addObject:temp];
        }
    }

    NSRange range = NSMakeRange(sender.tag, 1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tblCarOptions reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
}


-(void)loadAddCarPhotos{
    AddCarPhotosViewController *addCarPhotos = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCarPhotosViewController"];
    [WSLoading dismissLoading];
    [self.navigationController pushViewController:addCarPhotos animated:YES];
}

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveOptionalFeatures {
    NSString *jsonString;
    NSMutableArray *options = [NSMutableArray array];
    
    for (NSIndexPath *tempIndexPath in arrSelectedIndex) {
        NSString *highlights = [[[arrOptions objectAtIndex:tempIndexPath.section] objectForKey:@"options"] objectAtIndex:tempIndexPath.row];
        [options addObject:highlights];
    }
    if(options.count > 0) {
        NSError *error;
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:options options:NSJSONWritingPrettyPrinted error:&error];
        jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    }else {
        jsonString = @" ";
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            jsonString,@"hInsert",
                            [WSLoading getUserDefaultValueFromKey:@"vehicle_id"],@"vehicle_id",
                            [WSLoading getUserDefaultValueFromKey:@"car_type"],@"car_type",
                            nil];
    
//    NSDictionary *headers = [NSDictionary dictionaryWithObject:[WSLoading getCurrentUserDetailForKey:@"auth_key"] forKey:@"AUTH_KEY"];

    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,SAVE_HIGHLIGHTS];
    
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        
        NSError* error;
//        NSString *json = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        
        NSLog(@"JSON:%@",json);
        
        if([[[json objectForKey:@"success"] lowercaseString] isEqualToString:@"true"]) {
            [self loadAddCarPhotos];
        }else {
            [WSLoading dismissLoading];
            [WSLoading showAlertWithTitle:@"Error" Message:[json objectForKey:@"error_message"]];
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
