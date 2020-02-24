//
//  AddCarPhotosViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 06/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "AddCarPhotosViewController.h"
#import "AddCarHistoryViewController.h"
#import "UIImage+Resize.h"
#import "AddDamagedPhotosController.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "WSLoading.h"
#import "AFNetworking.h"
#import "VehicleDetails.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+FixOrientation.h"

#define Vivid_Yellow [UIColor colorWithRed:255/255.0 green:212/255.0 blue:7/255.0 alpha:1.0];

@interface AddCarPhotosViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    int imgCount,totalImages;
    NSMutableArray *arrImages,*arrImgId;
}
@property (weak, nonatomic) IBOutlet UILabel *lblVehicleName;
@property (weak, nonatomic) IBOutlet UILabel *lblDealerName;
@property (nonatomic, copy) NSArray *assets;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;

@property (weak, nonatomic) IBOutlet UIScrollView *buttonScroll;

@property (weak, nonatomic) IBOutlet UIPageControl *imagePage;

@property (weak, nonatomic) IBOutlet UIPageControl *buttonPage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorForButtonScroll;

@property BOOL isLoaded;
@end

@implementation AddCarPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLoaded = NO;
    // Do any additional setup after loading the view.
    arrImages = [NSMutableArray array];
    arrImgId = [NSMutableArray array];
    imgCount = 0,totalImages = 0;
    [self.tabBarController setTitle:@"ADD PHOTOS"];
    UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
    [tempButton addTarget:self action:@selector(btnAddImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tempButton setBackgroundColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0]];
    [tempButton setImage:[UIImage imageNamed:@"addCar"] forState:UIControlStateNormal];
    [_buttonScroll addSubview:tempButton];
    [_buttonScroll setContentSize:CGSizeMake(CGRectGetWidth(tempButton.frame),CGRectGetHeight(_buttonScroll.frame))];

//    for (int i = 0; i<20; i++) {
//        UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(i*(140 + 20), 0, 140, 140)];
//        
//        [tempButton setImage:[UIImage imageNamed:@"addCar"] forState:UIControlStateNormal];
//        [tempButton setHidden:YES];
//        
//        tempButton.tag = i;
//        
//        [tempButton addTarget:self action:@selector(btnAddImageClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [tempButton setBackgroundColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0]];
//        [_buttonScroll addSubview:tempButton];
//        [_buttonScroll setContentSize:CGSizeMake(CGRectGetWidth(tempButton.frame) * i,CGRectGetHeight(_buttonScroll.frame))];
//        //        [_buttonScroll setContentOffset:CGPointMake(CGRectGetWidth(tempButton.frame) * i,0) animated:YES];
//        if(i == 0) {
//            [tempButton setHidden:NO];
//        }
//    }
//    
    [_lblDealerName setText:[WSLoading getCurrentUserDetailForKey:@"display_name"]];
    
    [_lblVehicleName setText:[WSLoading getUserDefaultValueFromKey:@"vehicleName"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.tabBarController.title = @"ADD PHOTOS";
    // Add bar button items
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
    
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"true_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(uploadPhotos:)];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"true_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(openDamagePhotos:)];
    
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButton;
    
    
    [self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    [self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[CTAssetsPickerController class], nil];
    
    navBar.tintColor = Vivid_Yellow;
    [self.indicatorForButtonScroll setHidden:true];
    if([VehicleDetails sharedInstance].images.count > 0 && !_isLoaded) {
        [self.indicatorForButtonScroll setHidden:false];
        dispatch_async(dispatch_get_main_queue(), ^{

            
            [self addImages];
        });
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.tabBarController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
}


#pragma mark - Custom Methods

-(void)scrollToImage:(UIButton *)sender {
    NSLog(@"Scroll Image");
    CGRect scrollFrame = _imageScroll.frame;
    
    [_imageScroll setContentOffset:CGPointMake(scrollFrame.size.width * sender.tag,0) animated:YES];
}

-(void)addImages {
    [_buttonScroll setScrollEnabled:YES];
    int j = 0;
    totalImages = (int)[VehicleDetails sharedInstance].images.count;
    for (ImageInfo *tempInfo in [VehicleDetails sharedInstance].images) {
        [arrImgId addObject:tempInfo.image_id];
       __block UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(j*(140 + 20), 0, 140, 140)];

        tempButton.tag = j;
        [tempButton addTarget:self action:@selector(scrollToImage:) forControlEvents:UIControlEventTouchUpInside];
        CGRect scrollFrame = _imageScroll.frame;
        
        __block UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollFrame.size.width * j,0,scrollFrame.size.width,scrollFrame.size.height)];
        [imgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?w=800&h=600",tempInfo.imageUrl]]] placeholderImage:[UIImage imageNamed:@"tempCar"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            if (image) {
                [arrImages addObject:image];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imgView setImage:[image imageByScalingAndCroppingForSize:imgView.frame.size]];
                    [tempButton setImage:[image imageByScalingAndCroppingForSize:tempButton.frame.size] forState:UIControlStateNormal];
                    [tempButton setHidden:NO];
                    
                    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(tempButton.frame.origin.x, 0, 30, 30)];
                    //        [deleteButton setBackgroundColor:[UIColor redColor]];
                    [deleteButton setImage:[UIImage imageNamed:@"deleteImage"] forState:UIControlStateNormal];
                    deleteButton.tag = j;
                    [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    [self.buttonScroll addSubview:tempButton];
                    [_buttonScroll addSubview:deleteButton];
//  [self.buttonScroll setContentSize:CGSizeMake((tempButton.frame.size.width+20) * j, tempButton.frame.size.height)];

                });
            } else {
                imgView = nil;
            }
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
        
        
        [_imageScroll addSubview:imgView];

        j++;
        if([VehicleDetails sharedInstance].images.count < 20) {
            
            [_imageScroll setContentSize:CGSizeMake(scrollFrame.size.width * j, scrollFrame.size.height)];
            [self.buttonScroll setContentSize:CGSizeMake((tempButton.frame.size.width+20) * [VehicleDetails sharedInstance].images.count, tempButton.frame.size.height)];
            [self.buttonScroll setScrollEnabled:YES];
            [WSLoading dismissLoading];
        }
        
        if(j == [VehicleDetails sharedInstance].images.count) {
            
            UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(totalImages * (140 + 20), 0, 140, 140)];
            tempButton.tag = totalImages;
            [tempButton setImage:[UIImage imageNamed:@"addCar"] forState:UIControlStateNormal];
            
            [tempButton addTarget:self action:@selector(btnAddImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [tempButton setBackgroundColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0]];
            if([VehicleDetails sharedInstance].images.count < 20) {

                [_buttonScroll addSubview:tempButton];
            }
                [_buttonScroll setContentSize:CGSizeMake((CGRectGetWidth(tempButton.frame) + 20) * totalImages,CGRectGetHeight(_buttonScroll.frame))];
                [self.buttonScroll setContentSize:CGSizeMake(self.buttonScroll.contentSize.width+140, tempButton.frame.size.height)];
            

//            tempButton = (UIButton *)[_buttonScroll viewWithTag:j];
//            [tempButton setHidden:NO];
//            [tempButton setUserInteractionEnabled:true];
            _isLoaded = YES;
//            [self.buttonScroll setContentSize:CGSizeMake(self.buttonScroll.contentSize.width+140+20, tempButton.frame.size.height)];
            
            
        }
    }
    
    [self.indicatorForButtonScroll setHidden:true];
    imgCount = (int)[VehicleDetails sharedInstance].images.count;
    totalImages = (int)[VehicleDetails sharedInstance].images.count;
    
    [self.imagePage setNumberOfPages:imgCount];
    CGFloat imgPageIndex = _imageScroll.contentOffset.x / CGRectGetWidth(_imageScroll.frame);
    self.imagePage.currentPage = lround(imgPageIndex);

}
-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)openDamagePhotos:(id)sender {
   if(totalImages >= 5) {//rajesh
      //  if(totalImages >= 1) {
        AddDamagedPhotosController *addDamagedPhotos = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDamagedPhotosController"];
        [self.navigationController pushViewController:addDamagedPhotos animated:YES];
    }else {
        [WSLoading showAlertWithTitle:@"Alert" Message:@"Minimum 5 and maximum 20 images should be uploaded"];
    }
}

-(void)openCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)openGallery {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


-(IBAction)btnAddImageClicked:(UIButton *)sender {
    imgCount = (int)sender.tag;
    UIAlertController *alertAction = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertAction addAction:[UIAlertAction actionWithTitle:@"Gallary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openGallery];
    }]];
    [alertAction addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }]];
    [alertAction addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];

    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //activity.popoverPresentationController.sourceView = shareButtonBarItem;
        alertAction.modalPresentationStyle = UIModalPresentationPopover;
//        alertAction.popoverPresentationController.barButtonItem = rightBarButton;
        alertAction.popoverPresentationController.sourceView = sender;
        
        [self presentViewController:alertAction animated:YES completion:nil];
        
    } else {
        [self presentViewController:alertAction animated:YES completion:nil];
    }
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == _buttonScroll) {
        CGFloat pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        self.buttonPage.currentPage = lround(pageIndex);
    } else if (scrollView == _imageScroll) {
        CGFloat pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        self.imagePage.currentPage = lround(pageIndex);
    
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if(scrollView == _buttonScroll) {
        CGFloat pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        self.buttonPage.currentPage = lround(pageIndex);
    } else if (scrollView == _imageScroll) {
        CGFloat pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        self.imagePage.currentPage = lround(pageIndex);
        
    }
}

-(void)refreshScrollView {
    [_imageScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_buttonScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < arrImages.count; i++) {
        UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(i*(140 + 20), 0, 140, 140)];
        
        [tempButton setImage:[arrImages objectAtIndex:i] forState:UIControlStateNormal];

        tempButton.tag = i;
        
        [tempButton addTarget:self action:@selector(scrollToImage:) forControlEvents:UIControlEventTouchUpInside];
        [tempButton setBackgroundColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0]];
        [_buttonScroll addSubview:tempButton];

        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(tempButton.frame.origin.x, 0, 30, 30)];
//        [deleteButton setBackgroundColor:[UIColor redColor]];
        [deleteButton setImage:[UIImage imageNamed:@"deleteImage"] forState:UIControlStateNormal];
        deleteButton.tag = i;
        [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonScroll addSubview:deleteButton];
        
        
        CGRect scrollFrame = _imageScroll.frame;
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollFrame.size.width * i,0,scrollFrame.size.width,scrollFrame.size.height)];
        [imgView setImage:[[arrImages objectAtIndex:i] imageByScalingAndCroppingForSize:_imageScroll.frame.size]];
        
        [_imageScroll addSubview:imgView];
        [_imageScroll setContentOffset:CGPointMake(scrollFrame.size.width * i,0) animated:YES];
//        imgCount++;
        //    [self.buttonScroll setContentSize:CGSizeMake((btnTemp.frame.size.width+20) * imgCount, btnTemp.frame.size.height)];
        
            [_imageScroll setContentSize:CGSizeMake(scrollFrame.size.width * i, scrollFrame.size.height)];
            
            
       

        
        if(i == arrImages.count - 1) {
            [_buttonScroll setScrollEnabled:YES];
            UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(arrImages.count * (140 + 20), 0, 140, 140)];
            tempButton.tag = arrImages.count;
            [tempButton setImage:[UIImage imageNamed:@"addCar"] forState:UIControlStateNormal];
            
            [tempButton addTarget:self action:@selector(btnAddImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [tempButton setBackgroundColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0]];
            if(arrImages.count < 20) {
                [_buttonScroll addSubview:tempButton];
            }
                [_buttonScroll setContentSize:CGSizeMake((CGRectGetWidth(tempButton.frame) + 20) * arrImages.count,CGRectGetHeight(_buttonScroll.frame))];
                [self.buttonScroll setContentSize:CGSizeMake(self.buttonScroll.contentSize.width+140, tempButton.frame.size.height)];
            
            [_imageScroll setContentSize:CGSizeMake(scrollFrame.size.width * arrImages.count, scrollFrame.size.height)];
            
            [self.imagePage setNumberOfPages:imgCount];
            CGFloat imgPageIndex = _imageScroll.contentOffset.x / CGRectGetWidth(_imageScroll.frame);
            self.imagePage.currentPage = lround(imgPageIndex);
         
        }

    }
    
    if(arrImages.count == 0) {
        UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
        [tempButton addTarget:self action:@selector(btnAddImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tempButton setBackgroundColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0]];
        [tempButton setImage:[UIImage imageNamed:@"addCar"] forState:UIControlStateNormal];
        [_buttonScroll addSubview:tempButton];
        [_buttonScroll setContentSize:CGSizeMake(CGRectGetWidth(tempButton.frame),CGRectGetHeight(_buttonScroll.frame))];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,_imageScroll.frame.size.width,_imageScroll.frame.size.height)];
        [imgView setImage:[UIImage imageNamed:@"tempCar"]];
        
        [_imageScroll addSubview:imgView];

    }
}

-(void)deleteImage:(UIButton *)sender {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [WSLoading getUserDefaultValueFromKey:@"vehicle_id"],@"vehicle_id",
                            [WSLoading getUserDefaultValueFromKey:@"car_type"],@"car_type",
                            [arrImgId objectAtIndex:sender.tag],@"image_id",
                            nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,DELETEIMAGE];
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        
        NSLog(@"JSON:%@",json);
        if([json objectForKey:@"success_message"]){
            totalImages--;
            [arrImages removeObjectAtIndex:sender.tag];
            [self refreshScrollView];
        }
        
    }];
}

#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
   
    tempImage = [tempImage fixOrientation];
    
    CGFloat compression = 0.5f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 500*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(tempImage, compression);
    
    if(imageData != nil) {
        NSLog(@"ImageData size(kb):%f",imageData.length/1024.0f);
        while ([imageData length] > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(tempImage, compression);
        }
        
        NSLog(@"ImageData size(kb):%f",imageData.length/1024.0f);
    }
    
    if([WSLoading isNetAvailable]) {
        [WSLoading showLoading];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [WSLoading getUserDefaultValueFromKey:@"vin_id"],@"vin",
                                [WSLoading getUserDefaultValueFromKey:@"vehicle_id"],@"vehicle_id",
                                [WSLoading getUserDefaultValueFromKey:@"car_type"],@"car_type",
                                @"image",@"file_type",
                                @"0",@"isdamage",
                                nil];
        
        
        AFHTTPRequestSerializer *httpRequest = [AFHTTPRequestSerializer serializer];
        [httpRequest setValue:[Login sharedInstance].auth_key forHTTPHeaderField:@"AUTH-KEY"];
        
        NSMutableURLRequest *request = [httpRequest multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",BaseURL,UPLOAD_MEDIA] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
            NSString *timestamp=[NSString stringWithFormat:@"%ld",unixTime];
               [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"image%@.jpg",timestamp] mimeType:@"image/jpeg"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //                              [progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          [WSLoading dismissLoading];
                          if (error) {
                              NSLog(@"Error: %@", error);
                              NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
                              
                              NSError* error;
                              //                NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                              if(data != nil) {
                                  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:NSJSONReadingAllowFragments
                                                                                         error:&error];
                                  NSLog(@"json:%@",json);
                              }
                           
                          } else {
                              [self refreshScrollView];
                              NSData *data = responseObject;
                              
                              NSError* error;
                              //                NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                              NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:NSJSONReadingAllowFragments
                                                                                     error:&error];
                              
                              
                              [arrImgId addObject:[[json objectForKey:@"images"] valueForKey:@"image_id"]];
                              NSLog(@"json:%@",json);
                              NSLog(@"%@ %@", response, responseObject);
                          }
                      }];
        
        [uploadTask resume];
        
    }else {
        [WSLoading showAlertWithTitle:@"No Internet" Message:@"Internet is not available"];
    }

    [arrImages addObject:tempImage];
    
    CGRect scrollFrame = _imageScroll.frame;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollFrame.size.width * imgCount,0,scrollFrame.size.width,scrollFrame.size.height)];
    [imgView setImage:[tempImage imageByScalingAndCroppingForSize:_imageScroll.frame.size]];
    
    [_imageScroll addSubview:imgView];
    [_imageScroll setContentOffset:CGPointMake(scrollFrame.size.width * imgCount,0) animated:YES];
    imgCount++;
//    [self.buttonScroll setContentSize:CGSizeMake((btnTemp.frame.size.width+20) * imgCount, btnTemp.frame.size.height)];
    if(totalImages < 20 && totalImages == imgCount - 1) {
        totalImages++;
        [_imageScroll setContentSize:CGSizeMake(scrollFrame.size.width * imgCount, scrollFrame.size.height)];
        
        
    }
    
    [self.buttonPage setNumberOfPages:3];
    CGFloat pageIndex = _buttonScroll.contentOffset.x / CGRectGetWidth(_buttonScroll.frame);
    self.buttonPage.currentPage = lround(pageIndex);
    
    [self.imagePage setNumberOfPages:imgCount];
    CGFloat imgPageIndex = _imageScroll.contentOffset.x / CGRectGetWidth(_imageScroll.frame);
    self.imagePage.currentPage = lround(imgPageIndex);
//    
//    btnTemp = (UIButton *)[_buttonScroll viewWithTag:imgCount];
//    [btnTemp setImage:[UIImage imageNamed:@"addCar"] forState:UIControlStateNormal];
//    [btnTemp setHidden:NO];


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
