//
//  BLEGatesService.m
//  BLEGateKeeper
//
//  Created by Michał Woś on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import "BLEGatesService.h"
#import "BLERESTConnector.h"

@implementation BLEGatesService

-(void)persistGates {
    
    BLERESTConnector *restConnector = [[BLERESTConnector alloc] init];
    [restConnector gatesWithSuccess:^(NSArray *gates) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        for (BLEGateBasic *gateBasic in gates) {
            [userDefaults setValue:[NSNumber numberWithInt: gateBasic.id] forKey:[NSString stringWithFormat:@"%d,%d", gateBasic.major, gateBasic.minor]];
        }
        [userDefaults synchronize];
    }];
}

-(NSInteger)gateIdForMajor:(NSInteger)major minor:(NSInteger)minor {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [userDefaults valueForKey:[NSString stringWithFormat:@"%d,%d", major, minor]];
    return [number integerValue];
}

@end
