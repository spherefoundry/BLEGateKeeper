//
//  BLEMainViewController.m
//  BLEGateKeeper
//
//  Created by Michal Tuszynski on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import "BLEMainViewController.h"
#import "ESTBeaconManager.h"

static const ESTBeaconMajorValue kBeaconMajor = 26814;
static const ESTBeaconMinorValue kBeaconMinor = 62718;

@interface BLEMainViewController () <ESTBeaconManagerDelegate>

@property(strong, nonatomic) ESTBeaconManager *beaconManager;

@end

@implementation BLEMainViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"Starting beacon monitoring");
  ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initRegionWithMajor:kBeaconMajor
                                                                   minor:kBeaconMinor
                                                              identifier:@"EstimoteSalmpleRegion"];
  self.beaconManager = [[ESTBeaconManager alloc] init];
  self.beaconManager.delegate = self;
  [self.beaconManager startRangingBeaconsInRegion:region];
}

#pragma mark - ESTBeaconManagerDelegate

- (void)beaconManager:(ESTBeaconManager *)manager
      didRangeBeacons:(NSArray *)beacons
             inRegion:(ESTBeaconRegion *)region {
  NSLog(@"Found beacons: %@", beacons);
}

-(void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error {
  NSLog(@"Failed: %@", error);
}


@end
