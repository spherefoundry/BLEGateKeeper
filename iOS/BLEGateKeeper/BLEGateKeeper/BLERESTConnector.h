//
//  BLERESTConnector.h
//  BLEGateKeeper
//
//  Created by Michał Woś on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEGate.h"

@interface BLERESTConnector : NSObject

-(void)gatesWithSuccess:(void (^)(NSArray *gates))success;
-(void)gateForId:(NSInteger)gateId withSuccess:(void (^)(BLEGate *gate))success;
-(void)openGate;
-(void)closeGate;

@end
