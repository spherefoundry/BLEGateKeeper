//
//  BLEGateListElem.h
//  BLEGateKeeper
//
//  Created by Michał Woś on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEGateBasic : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger major;
@property (nonatomic) NSInteger minor;
@property (nonatomic, strong) NSString *name;

@end
