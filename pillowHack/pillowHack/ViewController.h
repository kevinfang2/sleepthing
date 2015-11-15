//
//  ViewController.h
//  pillowHack
//
//  Created by Kevin Fang on 11/14/15.
//  Copyright © 2015 Kevin Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Healthkit/HealthKit.h>

@interface ViewController : UIViewController

+ (CFTimeInterval *)buttonPressedStartTime;

@property (strong, nonatomic) IBOutlet UIView *objectView;

@end

