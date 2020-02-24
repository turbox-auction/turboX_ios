//
//  VinScanViewController.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 25/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "VinScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VinScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *scanView;

@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

@end

@implementation VinScanViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    supportedCodes = @[AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code];

    
    _codeView.layer.borderColor = [UIColor greenColor].CGColor;
    _codeView.layer.borderWidth = 2.0;
    
    
    _captureSession = [[AVCaptureSession alloc]init];
    
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if(input) {
        [_captureSession addInput:input];
    } else {
        NSLog(@"Error:%@",error.localizedDescription);
        return;
    }
    
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc]init];
    
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_captureSession addOutput:captureMetadataOutput];
    [captureMetadataOutput setMetadataObjectTypes:supportedCodes];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_scanView.layer.bounds];
    [_scanView.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
    [self.view bringSubviewToFront:_codeView];
}

-(void)viewDidLayoutSubviews {
    [_videoPreviewLayer setFrame:_scanView.layer.bounds];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVCapture MetaData Delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if(metadataObjects == nil || metadataObjects.count == 0) {
        [_lblMessage setHidden:NO];
        return;
    }
    
    AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
//    AudioServicesPlaySystemSound(1005);
    SystemSoundID soundID;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/beep.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound (soundID);
    
    if ([supportedCodes containsObject:metadataObj.type]) {
        // Get the metadata object.
        AudioServicesPlayAlertSoundWithCompletion(1103, ^{
            
        });
        
        [_lblMessage setHidden:YES];
        NSString *vinNumber = [metadataObj stringValue];
        if([self.delegate respondsToSelector:@selector(vinScanViewControllerDismissed:)]) {
            [self.delegate vinScanViewControllerDismissed:vinNumber];
        }
        NSLog(@"Data:%@",[metadataObj stringValue]);
        [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
    }
    
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(void)orientationChanged:(NSNotification *)notif {
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    // Calculate rotation angle
    CGFloat angle;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIDeviceOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
        case UIDeviceOrientationLandscapeRight:
            angle = - M_PI_2;
            break;
        default:
            angle = 0;
            break;
    }
    
    [UIView animateWithDuration:.3 animations:^{
        self.codeView.transform = CGAffineTransformMakeRotation(angle);
        [self.codeView setNeedsUpdateConstraints];
        [self.codeView setNeedsLayout];
        [self.codeView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - UIButton Actions
- (IBAction)btnCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Cusotm Selector

-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
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
