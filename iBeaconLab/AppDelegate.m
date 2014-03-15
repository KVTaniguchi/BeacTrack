//
//  AppDelegate.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/8/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@implementation AppDelegate{
    CLLocationManager *locationManager;
    CLBeaconRegion *beaconRegion;
    BOOL _isInRegion;
    MainViewController *mvc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isInRegion = NO;
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        //    static NSString *UUIDADVERT = @"D0548F44-7170-4BAA-AFDA-7F82076E6A25";
        //    static NSString *UUIDADVERT = @"A6AA4D3A-9A27-921B-5DA7-8E704FAA936A";  // from leDict.plist
        
        // mac beacon D0548F44-7170-4BAA-AFDA-7F82076E6A25
        //673E2B62-5B2C-4BB0-876D-87BCAA06D66F
        static NSString *UUIDADVERT = @"D0548F44-7170-4BAA-AFDA-7F82076E6A25";  // from value for device id
        NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:UUIDADVERT];
        beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:@"beacon"];
        beaconRegion.notifyEntryStateOnDisplay = YES;
        beaconRegion.notifyOnEntry = YES;
        beaconRegion.notifyOnExit = YES;
        [locationManager startMonitoringForRegion:beaconRegion];
    });
    return YES;
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

-(void)_sendEnterLocalNotification{
    NSLog(@"sendEnter notif called");
        UILocalNotification *enterNotification = [[UILocalNotification alloc]init];
        enterNotification.alertBody = @"Inside Beacon Region";
        enterNotification.alertAction = @"Open";
        [[UIApplication sharedApplication]scheduleLocalNotification:enterNotification];
    _isInRegion = YES;
}

-(void)_sendExitLocalNotification{
    NSLog(@"sendExit notif called");
        UILocalNotification *leaveNotification = [[UILocalNotification alloc]init];
        leaveNotification.alertBody = @"Left Beacon Region";
        leaveNotification.alertAction = @"Open";
        [[UIApplication sharedApplication]scheduleLocalNotification:leaveNotification];
    _isInRegion = NO;
}

-(void)_updateUIForState:(CLRegionState)state{
//    mvc = (MainViewController*)self.window.rootViewController;
    if (state == CLRegionStateInside) {
        NSLog(@"inside");
    }
    else if (state == CLRegionStateOutside){
        NSLog(@"outside");
    }
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
    NSLog(@"did determine state");
    [self _updateUIForState:state];
    if (state == CLRegionStateInside) {
        [self _sendEnterLocalNotification];
    }
    else{
        [self _sendExitLocalNotification];
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    if ([beacons count] > 0) {
        CLBeacon *beacon = [beacons lastObject];
        NSLog(@"app del did range beacon: %@", beacon.proximityUUID);
        _isInRegion = YES;
    }
    else{
        NSLog(@"NOT ranging");
        _isInRegion = NO;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"ERROR: %@", error.description);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"didd start monotring called: locationManager did start monitoring");
    [locationManager startRangingBeaconsInRegion:beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"did enter region called");
    _isInRegion = YES;
    [locationManager startRangingBeaconsInRegion:beaconRegion];
    [self _sendEnterLocalNotification];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"did exit the region");
    _isInRegion = NO;
    [self _sendExitLocalNotification];
}


@end
