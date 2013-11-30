//
//  BLERESTConnector.m
//  BLEGateKeeper
//
//  Created by Michał Woś on 30/11/13.
//  Copyright (c) 2013 Appvetica. All rights reserved.
//

#import "BLERESTConnector.h"
#import "AFNetworking.h"

#define TOKEN_KEY @"TOKEN_KEY"

@implementation BLERESTConnector

//-(void)authenticate:(void (^)(BOOL))success {
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager POST:@"http://localhost" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        NSString *token = [responseObject valueForKey:@""];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        if (token != nil) {
//            [userDefaults setValue:token forKey:TOKEN_KEY];
//            [userDefaults synchronize];
//            success(TRUE);
//        } else {
//            success(FALSE);
//        }
//    } failure:nil];
//}

-(void)gatesWithSuccess:(void (^)(NSArray *))success {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"http://10.0.3.155:5000/gate/list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSMutableArray *gates = [[NSMutableArray alloc] init];
        for (NSDictionary *jsonGate in responseObject) {
            BLEGateBasic *gate = [[BLEGateBasic alloc] init];
            [gate setValuesForKeysWithDictionary:jsonGate];
            [gates addObject:gate];
        }
        success(gates);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)gateForId:(NSInteger)gateId withSuccess:(void (^)(BLEGate *))success {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://10.0.3.155:5000/gate/%d/", gateId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        BLEGate *gate = [[BLEGate alloc] init];
        [gate setValuesForKeysWithDictionary:responseObject];
        success(gate);
    } failure:nil];
}

-(void)openGateForId:(NSInteger)gateId withSuccess:(void (^)(BLEGate *))success {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"http://10.0.3.155:5000/gate/%d/", gateId] parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"open", @"action", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BLEGate *gate = [[BLEGate alloc] init];
        [gate setValuesForKeysWithDictionary:responseObject];
        success(gate);
    } failure:nil];
}

-(void)closeGateForId:(NSInteger)gateId withSuccess:(void (^)(BLEGate *))success {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"http://10.0.3.155:5000/gate/%d/", gateId] parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"close", @"action", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BLEGate *gate = [[BLEGate alloc] init];
        [gate setValuesForKeysWithDictionary:responseObject];
        success(gate);
    } failure:nil];
}

@end
