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
#import <ImageIO/CGImageProperties.h>
#import <Firebase/Firebase.h>

#define _width self.view.frame.size.width
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface ViewController ()
{
    CMMotionManager* motionManager;
    UIImageView* capturedView;
    UIButton* capture;
    UILabel* label;
    UILabel* counter;
    AVCaptureStillImageOutput* stillImageOutput;
    
    int count;
    float angle;
    __block float yTotal;
    GSHealthKitManager *sleep;
    
    float totalangle;
    float anglescounted;
    
    int lightticks;
    
}


@end

@implementation ViewController {
    
    __weak IBOutlet UIButton *start;
    __weak IBOutlet UIButton *end;
    __weak IBOutlet UIButton *camera;

}

int a=1;
- (IBAction)start:(id)sender {
    [self camera];
    [self frontCamera];
    [self gyroscope];
    [self timer];
    a=1;
    start.hidden = YES;
    end.hidden = NO;

    
}

- (IBAction)end:(id)sender {
    a=2;
    start.hidden= NO;
    end.hidden = YES;
    
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://pillowhack.firebaseio.com"];
    // Write data to Firebase
    NSNumber *disturbances = [NSNumber numberWithInt:occurances];
    [[myRootRef childByAppendingPath:@"disturbances"] setValue: disturbances];
    
    [[myRootRef childByAppendingPath:@"timeslept"] setValue: [NSNumber numberWithInt:count]];
    
    [[myRootRef childByAppendingPath:@"averageangle"] setValue: [NSNumber numberWithFloat:totalangle/anglescounted]];
    
    [[myRootRef childByAppendingPath:@"timelight"] setValue: [NSNumber numberWithFloat:totalangle/lightticks]];
    
    
}

- (IBAction)camera:(id)sender {
//    [self camera];
}




int occurances=0;

- (void)gyroscope{
    yTotal = 0;
    if(a == 1){
        UILabel* yLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
        [self.view addSubview:yLabel];
        yLabel.textAlignment = NSTextAlignmentCenter;
        yLabel.text = @"trolled";
        
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
                     totalangle += degs;
                     anglescounted++;
//                     int x;
//                     for(x=0;x>=0;x++){
//                         yTotal = degs + yTotal;
                         if(degs > 50.0 || degs < -50.0){
                             int x = 1;
                             occurances = x + occurances;
                             NSLog(@"%d",occurances);
                         }
//                     }
                     float average = totalangle;
                     NSString *y = [[NSString alloc] initWithFormat:@"%.02f %f",average,anglescounted];
//                     NSLog(y);
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
        
        [self capture];
        
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

-(void) tick2:(NSTimer*)timer
{
    
        count = count - 1;
        label.text = [NSString stringWithFormat:@"%d",count];
        if(count == 0)
        {
            count = 4;
            [self capture];
            NSLog(@"herp1");
            
        }
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

-(void) camera{
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
    
    //    capturedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dWidth, dHeight)];
    //    //    capturedView.image = image;
    //    [self.view addSubview:capturedView];
    
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];


}

- (void)viewDidLoad {
    [super viewDidLoad];
}
    


-(void) capture
{
    
    NSLog(@"capture");
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
         }
         else
         {
             NSLog(@"no attachments");
         }
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];

         
         if(isDarkImage(image))
         {
            NSLog(@"dark");
         }
         else
         {
             
             NSLog(@"light");
             lightticks++;
         }
         
     }];
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
