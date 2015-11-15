//
//  ViewController.m
//  pillowHack
//
//  Created by Kevin Fang on 11/14/15.
//  Copyright © 2015 Kevin Fang. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import <healthkit/healthkit.h>
#define _width self.view.frame.size.width
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface ViewController ()
{
    CMMotionManager* motionManager;
    UIImageView* capturedView;
    UIButton* capture;
    UILabel* label;
    int count;
    float angle;
    __block float yTotal;
}

@end

@implementation ViewController {
    
    __weak IBOutlet UIButton *start;
    __weak IBOutlet UIButton *end;
}
int a;
- (IBAction)start:(id)sender {
//    [self gyroscope];
    start.hidden = YES;
    end.hidden = NO;
    
}
- (IBAction)end:(id)sender {
    NSLog(@"asdf");
    start.hidden= NO;
    end.hidden = YES;
}


//- (void)timer{
//    NSTimer *timer = [[timer alloc] init];
//    
//    [timer startTimer];
//    // Do some work
//    [timer stopTimer];
//    
//    NSLog(@"Total time was: %lf milliseconds", [timer timeElapsedInMilliseconds]);
//    NSLog(@"Total time was: %lf seconds", [timer timeElapsedInSeconds]);
//    NSLog(@"Total time was: %lf minutes", [timer timeElapsedInMinutes]);
//    
//}
- (void)gyroscope{
    if(start.hidden == NO){
        yTotal = 0;
        [super viewDidLoad];
        NSLog(@"asdf");
        UILabel* yLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _width, 50)];
        [self.view addSubview:yLabel];
        yLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel* yLabelChange = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, _width, 50)];
        [self.view addSubview:yLabelChange];
        yLabelChange.textAlignment = NSTextAlignmentCenter;
        
        motionManager = [[CMMotionManager alloc] init];
        if([motionManager isGyroAvailable])
        {
            if([motionManager isGyroActive] == NO)
            {
                [motionManager setGyroUpdateInterval:1.0f / 10.0f];
                [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                           withHandler:^(CMGyroData *gyroData, NSError *error)
                 {
                     float degs = RADIANS_TO_DEGREES(gyroData.rotationRate.y) / 10;
                     degs = degs - 0.4;
                     if(degs > 0.2 || degs < -0.2)
                     {
                         yTotal = yTotal + degs;
                     }
                     NSString *y = [[NSString alloc] initWithFormat:@"%.02f",yTotal];
                     angle = yTotal;
                     yLabel.text = y;
                     yLabelChange.text = [[NSString alloc] initWithFormat:@"%.02f",degs];
                     //                 [myRootRef setValue:[NSNumber numberWithFloat:yTotal]];
                 }];
            }
            //        [self sleeptimer];
        }
    }
}

- (AVCaptureDevice *)frontCamera {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    AVCaptureDevice *device = [self frontCamera];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    [session addInput:input];
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    newCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    newCaptureVideoPreviewLayer.frame = CGRectMake(0, 0, _width, self.view.frame.size.height);
    //    newCaptureVideoPreviewLayer.la
    [self.view.layer addSublayer:newCaptureVideoPreviewLayer];
    [session startRunning];

    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}


- (void)viewDidLoad {
    end.hidden = YES;
//    [myRootRef setValue:0];
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
