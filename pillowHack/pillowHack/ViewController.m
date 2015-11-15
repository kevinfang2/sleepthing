//
//  ViewController.m
//  pillowHack
//
//  Created by Kevin Fang on 11/14/15.
//  Copyright © 2015 Kevin Fang. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
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

@implementation ViewController

- (void)viewDidLoad {
//    [myRootRef setValue:0];
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
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
