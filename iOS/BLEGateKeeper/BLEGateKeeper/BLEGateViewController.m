//
//  BLEGateViewController.m
//  BLEGateKeeper
//
//  Created by Peter Tuszynski on 11/30/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import "BLEGateViewController.h"
#import "BLERESTConnector.h"

@interface BLEGateViewController (){
    IBOutlet UISegmentedControl *segmentedControl;
    BLERESTConnector *restConnector;
}


-(IBAction)segmentedControllValueChanged:(UISegmentedControl *)sender;

-(void)refreshGateDetails;

@end

@implementation BLEGateViewController
@synthesize gate;

#pragma mark - viewcontroller

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:[gate name]];
    [self refreshGateDetails];
}

#pragma mark - actions
-(void)refreshGateDetails{
    restConnector = [[BLERESTConnector alloc] init];
    [restConnector gateForId:[self.gate id] withSuccess:^(BLEGate *gate) {
        NSLog(@"TEST SINGLE: id = %d, major = %d, minor = %d, name = %@\n", gate.id, gate.major, gate.minor, gate.name);
        
        [segmentedControl setSelectedSegmentIndex:gate.state];
    }];
}

-(IBAction)segmentedControllValueChanged:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        //close
        [restConnector closeGateForId:[self.gate id] withSuccess:^(BLEGate *gate) {
            [self refreshGateDetails];
        }];
    }else{
        //open
        [restConnector openGateForId:[self.gate id] withSuccess:^(BLEGate *gate) {
            [self refreshGateDetails];
        }];
    }
}
@end
