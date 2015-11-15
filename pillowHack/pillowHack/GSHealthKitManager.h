//
//  GSHealthKitManager.h
//  pillowHack
//
//  Created by Kevin Fang on 11/15/15.
//  Copyright © 2015 Kevin Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSHealthKitManager : NSObject

+ (GSHealthKitManager *)sharedManager;

- (void)requestAuthorization;

- (void)sleepTime:(CGFloat)sleep;

@end
