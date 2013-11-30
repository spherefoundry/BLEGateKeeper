//
//  BLEAppDelegate.m
//  BLEGateKeeper
//
//  Created by Michal Tuszynski on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import "BLEAppDelegate.h"
#import "BLERESTConnector.h"
#import "BLEGatesService.h"

@implementation BLEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[[BLEGatesService alloc] init] persistGates];
    //[self test]
    return YES;
}

-(void)test {
    BLERESTConnector *restConnector = [[BLERESTConnector alloc] init];
    [restConnector gatesWithSuccess:^(NSArray *gates) {
        for (BLEGateBasic *gateBasic in gates) {
            NSLog(@"id = %d, major = %d, minor = %d, name = %@\n", gateBasic.id, gateBasic.major, gateBasic.minor, gateBasic.name);
        }
    }];
    
    [restConnector gateForId:2 withSuccess:^(BLEGate *gate) {
        NSLog(@"TEST SINGLE: id = %d, major = %d, minor = %d, name = %@\n", gate.id, gate.major, gate.minor, gate.name);
    }];
    
    [restConnector openGateForId:1 withSuccess:^(BLEGate *gate) {
        NSLog(@"STATE OF A GATE: %d", gate.state);
    }];
    [restConnector closeGateForId:1 withSuccess:^(BLEGate *gate) {
        NSLog(@"STATE OF A GATE: %d", gate.state);
    }];
    
    NSInteger gateId = [[[BLEGatesService alloc] init] gateIdForMajor:1 minor:1];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  //TODO Implement gate opening!
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gate open!"
                                                  message:@"Gate is open!"
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
  
  BLERESTConnector *restConnector = [[BLERESTConnector alloc] init];
  [restConnector openGateForId:1 withSuccess:^(BLEGate *gate) {
    NSLog(@"STATE OF A GATE: %d", gate.state);
  }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
