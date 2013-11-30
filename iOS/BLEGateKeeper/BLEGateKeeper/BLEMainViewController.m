//
//  BLEMainViewController.m
//  BLEGateKeeper
//
//  Created by Michal Tuszynski on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import "BLEMainViewController.h"
#import "ESTBeaconManager.h"

static const CLLocationAccuracy kBeaconRangeThreshold = 0.5;
static const ESTBeaconMajorValue kBeaconMajor = 26814;
static const ESTBeaconMinorValue kBeaconMinor = 62718;

@interface BLEMainViewController () <ESTBeaconManagerDelegate>

@property(strong, nonatomic) ESTBeaconManager *beaconManager;

-(void)p_showGateNotification;

@end

@implementation BLEMainViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"Starting beacon monitoring");
  ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initRegionWithMajor:kBeaconMajor
                                                                   minor:kBeaconMinor
                                                              identifier:@"EstimoteSampleRegion"];
  self.beaconManager = [[ESTBeaconManager alloc] init];
  self.beaconManager.delegate = self;
  [self.beaconManager startMonitoringForRegion:region];
}

#pragma mark - Internal
#pragma mark Local notifications

- (void)p_showGateNotification {
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  notification.alertBody = @"This is a test";
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - ESTBeaconManagerDelegate

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region {
  NSLog(@"Did enter region: %@", region);
  [self p_showGateNotification];
}

- (void)beaconManager:(ESTBeaconManager *)manager
      didRangeBeacons:(NSArray *)beacons
             inRegion:(ESTBeaconRegion *)region {
  if([beacons count] > 0) {
    ESTBeacon *beacon = beacons[0];
    NSLog(@"Distance: %f", beacon.ibeacon.accuracy);
  }
}

-(void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error {
  NSLog(@"Failed: %@", error);
}


@end
