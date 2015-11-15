//
//  GSHealthKitManager.m
//  pillowHack
//
//  Created by Kevin Fang on 11/15/15.
//  Copyright © 2015 Kevin Fang. All rights reserved.
//

#import "GSHealthKitManager.h"
#import <HealthKit/HealthKit.h>
#import "ViewController.h"

@interface GSHealthKitManager ()

@property (nonatomic, retain) HKHealthStore *healthStore;

@end


@implementation GSHealthKitManager{
    
}

+ (GSHealthKitManager *)sharedManager {
    static dispatch_once_t pred = 0;
    static GSHealthKitManager *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[GSHealthKitManager alloc] init];
        instance.healthStore = [[HKHealthStore alloc] init];
    });
    return instance;
}



- (void)requestAuthorization {
    
    if ([HKHealthStore isHealthDataAvailable] == NO) {
        // If our device doesn't support HealthKit -> return.
        return;
    }
    
    NSArray *readTypes = @[[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth]];
    
    NSArray *writeTypes = @[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]];
    
    [self.healthStore requestAuthorizationToShareTypes:[NSSet setWithArray:readTypes]
                                             readTypes:[NSSet setWithArray:writeTypes] completion:nil];
}



- (void)sleepTime:(CGFloat)sleep {
    HKCategoryType *categoryType =
    [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString);
    
    HKCategorySample *categorySample =
    [HKCategorySample categorySampleWithType:categoryType
                                       value:HKCategoryValueSleepAnalysisAsleep
                                   startDate:now
                                     endDate:now];
//    // Each quantity consists of a value and a unit.
//    HKUnit *kilogramUnit = [HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo];
//    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:kilogramUnit doubleValue:sleep];
//    
//    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    NSDate *now = [NSDate date];
//    
//    // For every sample, we need a sample type, quantity and a date.
//    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:now endDate:now];
//    
//    [self.healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
//        if (!success) {
//            NSLog(@"Error while saving weight (%f) to Health Store: %@.", weight, error);
//        }
//    }];
}

@end