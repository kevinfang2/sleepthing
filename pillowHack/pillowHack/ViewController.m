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
    UILabel* counter;
    int count;
    float angle;
    __block float yTotal;
}

@end

@implementation ViewController {
    
    __weak IBOutlet UIButton *start;
    __weak IBOutlet UIButton *end;
}

- (IBAction)start:(id)sender {
    [self gyroscope];
    [self timer];

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
int occurances=0;

- (void)gyroscope{
    yTotal = 0;
    if(start.hidden == NO){
        [super viewDidLoad];
        NSLog(@"asdf");
        UILabel* yLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
        [self.view addSubview:yLabel];
        yLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel* yLabelChange = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 50)];
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
                     float degs = RADIANS_TO_DEGREES(gyroData.rotationRate.y);
                     degs = degs - 0.4;
                     if(degs > 50.0 || degs < -50.0)
                     {
                         yTotal = degs;
//                         NSNumber *x = [NSNumber numberWithInt:3];
                         int x = 1;
                         occurances = x + occurances;
                         NSLog(@"%d",occurances);
                         
                         
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
    else{
//        [UILabel removeFromSuperview];
    }
}


-(void) tick:(NSTimer*)timer
{
    count = count + 1;
    [counter removeFromSuperview];

//     NSLog(@"derpasdf %d",count);
    counter = [[UILabel alloc] initWithFrame:CGRectMake(30, 350, _width, 30)];
    counter.text = [NSString stringWithFormat:@"%d hours   %d minutes   %d seconds",count/3600,(count/60)%60,count%60];
    [[self view] addSubview:counter];

    
}
- (void)timer{
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    UILabel* derp = [[UILabel alloc] initWithFrame:CGRectMake(70, 320, _width, 30)];
    derp.text = [NSString stringWithFormat:@"You've been sleeping for "];



//    counter.backgroundColor = [UIColor blueColor];
    [[self view] addSubview:derp];

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
    if(isDarkImage){
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tick:) userInfo:nil repeats:YES];

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

BOOL isDarkImage(UIImage* inputImage){
    
    BOOL isDark = FALSE;
    
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(inputImage.CGImage));
    const UInt8 *pixels = CFDataGetBytePtr(imageData);
    
    int darkPixels = 0;
    
    int length = CFDataGetLength(imageData);
    int const darkPixelThreshold = (inputImage.size.width*inputImage.size.height)*.75;
    
    for(int i=0; i<length; i+=4)
    {
        int r = pixels[i];
        int g = pixels[i+1];
        int b = pixels[i+2];
        
        //luminance calculation gives more weight to r and b for human eyes
        float luminance = (0.299*r + 0.587*g + 0.114*b);
        if (luminance<50) darkPixels ++;
    }
    
    if (darkPixels >= darkPixelThreshold)
        isDark = YES;
    
    CFRelease(imageData);
    
    return isDark;
    
}


@end
