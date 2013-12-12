//
//  BeaconChecker.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/10/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import "BeaconChecker.h"

@implementation BeaconChecker

-(id)init{
    
    if(self){
        [self registerBeaconRegionsForUUID:_UUIDtoCheck identifierToCheck:_identifierToCheck];
        NSLog(@"BeaconChecker created with values: %@", _UUIDtoCheck.UUIDString);
    }
    return self;
}

-(void)registerBeaconRegionsForUUID:(NSUUID*)uuid identifierToCheck:(NSString*)identifier{
    NSLog(@"RegisterBeaconsForRegions called for uuid: %@ with identifier: %@", uuid.UUIDString, identifier);
    _beaconRegionToCheck = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:identifier];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegionToCheck];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Did enter region Called");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegionToCheck];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    [self.locationManager stopMonitoringForRegion:self.beaconRegionToCheck];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    NSLog(@"didRangeBeacons called");
    
    _beaconsFound = [NSArray arrayWithArray:beacons];
}

-(void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
    NSLog(@"Error in ranging Beacons");
}

@end
