//
//  BLEGatesService.h
//  BLEGateKeeper
//
//  Created by Michał Woś on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEGateBasic.h"

@interface BLEGatesService : NSObject

-(void)persistGates;
-(NSInteger)gateIdForMajor:(NSInteger)major minor:(NSInteger)minor;

@end
