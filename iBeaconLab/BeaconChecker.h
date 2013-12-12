//
//  BeaconChecker.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/10/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//  Pass this class 1 UUID at a time - it creates a beaconRegion for it then tries to range that beaconRegion for beacons
//  when it gets a beacon then it

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconChecker : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *beaconsFound;
@property (nonatomic, strong) CLBeaconRegion *beaconRegionToCheck;
@property (nonatomic, strong) NSUUID *UUIDtoCheck;
@property (nonatomic, strong) NSString *identifierToCheck;
@end
