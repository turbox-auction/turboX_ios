//
//  VinScanViewController.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 25/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VinScanDelegate <NSObject>

-(void)vinScanViewControllerDismissed:(NSString *)vinString;

@end


@interface VinScanViewController : UIViewController
{
    id delegate;
    NSArray *supportedCodes;
}
@property (strong, nonatomic) id<VinScanDelegate> delegate;
@end
