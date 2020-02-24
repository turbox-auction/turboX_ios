//
//  DetailViewController.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 12/01/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Auction.h"
#import "Pusher.h"

@interface DetailViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollCarImages;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) Auction *currentAuction;

@property (strong, nonatomic) PTPusher *pusher;

@end
