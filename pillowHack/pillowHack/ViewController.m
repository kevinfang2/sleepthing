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
#import "GSHealthKitManager.h"
#import <CoreFoundation/CoreFoundation.h>
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
    GSHealthKitManager *sleep;
    
}


@end

@implementation ViewController {
    
    __weak IBOutlet UIButton *start;
    __weak IBOutlet UIButton *end;
}


- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}
int a=1;
- (IBAction)start:(id)sender {
    [self gyroscope];
    [self timer];
    [self frontCamera];
    a=1;
    start.hidden = YES;
    end.hidden = NO;

    
}



- (IBAction)end:(id)sender {
    a=2;
    NSLog(@"asdf");
    start.hidden= NO;
    end.hidden = YES;
}
//
//- (void)sleep{
//    HKCategoryType *categoryType =
//    [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
//    
//    NSDate* now= [NSDate date];
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setDateFormat:@"HH:mm:ss"];
//    NSString *newDateString = [outputFormatter stringFromDate:now];
//    NSLog(@"newDateString %@", newDateString);
//
//    [HKCategorySample categorySampleWithType:categoryType
//                                       value:HKCategoryValueSleepAnalysisAsleep
//                                   startDate:now
//                                     endDate:now];
//}

int occurances=0;

- (void)gyroscope{
    yTotal = 0;
    if(a == 1){
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
        }

    }
    else{
//        [UILabel removeFromSuperview];
    }
}


-(void) tick:(NSTimer*)timer
{
    if(a==1){
    count = count + 1;
    [counter removeFromSuperview];

//     NSLog(@"derpasdf %d",count);
    counter = [[UILabel alloc] initWithFrame:CGRectMake(30, 350, _width, 30)];
    counter.text = [NSString stringWithFormat:@"%d hours   %d minutes   %d seconds",count/3600,(count/60)%60,count%60];
    [[self view] addSubview:counter];
    }
    else{
        
    }
    
}

- (void)timer{
    if(a==1){
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tick:) userInfo:nil repeats:YES];
        UILabel* derp = [[UILabel alloc] initWithFrame:CGRectMake(70, 320, _width, 30)];
        derp.text = [NSString stringWithFormat:@"You've been sleeping for "];
        
        //    counter.backgroundColor = [UIColor blueColor];
        [[self view] addSubview:derp];
    }
    
}





//    if(&isDarkImage){
//        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tick:) userInfo:nil repeats:YES];
//        NSLog(@"asdf");
//
//    }
//    return nil;


 



- (void)viewDidLoad {
    [super viewDidLoad];
    //    [myRootRef setValue:0];
//    [self.view addSubview:sleep];

    
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
