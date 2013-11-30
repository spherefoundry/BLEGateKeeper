//
//  BLEMainViewController.m
//  BLEGateKeeper
//
//  Created by Michal Tuszynski on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import "BLEMainViewController.h"
#import "BLERESTConnector.h"
#import "ESTBeaconManager.h"
#import "BLEGateViewController.h"

static const CLLocationAccuracy kBeaconRangeThreshold = 0.5;
static const ESTBeaconMajorValue kBeaconMajor = 26814;
static const ESTBeaconMinorValue kBeaconMinor = 62718;

@interface BLEMainViewController () <ESTBeaconManagerDelegate>{
    IBOutlet UITableView *table;
    NSArray *gatesArray;
}

@property(strong, nonatomic) ESTBeaconManager *beaconManager;

-(void)p_showGateNotification;
-(void)p_loadGates;

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
  [self p_loadGates];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *ip = [table indexPathForSelectedRow];
    BLEGateViewController *destinationViewController = [segue destinationViewController];
    [destinationViewController setGate:[gatesArray objectAtIndex:ip.row]];
}

#pragma mark - Internal
#pragma mark Data loading

-(void)p_loadGates {
  BLERESTConnector *restConnector = [[BLERESTConnector alloc] init];
  [restConnector gatesWithSuccess:^(NSArray *gates) {
    gatesArray = gates;
    [table reloadData];
  }];

}

#pragma mark Local notifications

- (void)p_showGateNotification {
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  notification.alertBody = @"This is a test";
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}
#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
  
  BLEGateBasic *gate = gatesArray[indexPath.row];
  cell.textLabel.text = gate.name;
  
  return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [gatesArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"gateDetails" sender:self];
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
