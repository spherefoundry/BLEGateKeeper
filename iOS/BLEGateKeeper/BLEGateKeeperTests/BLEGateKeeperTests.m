//
//  BLEGateKeeperTests.m
//  BLEGateKeeperTests
//
//  Created by Michal Tuszynski on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLERESTConnector.h"

@interface BLEGateKeeperTests : XCTestCase

@end

@implementation BLEGateKeeperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    BLERESTConnector *restConnector = [[BLERESTConnector alloc] init];
    [restConnector gatesWithSuccess:^(NSArray *gates) {
        for (BLEGateBasic *gateBasic in gates) {
            NSLog(@"id = %d, major = %d, minor = %d, name = %@\n", gateBasic.id, gateBasic.major, gateBasic.minor, gateBasic.name);
        }
    }];
}

@end
