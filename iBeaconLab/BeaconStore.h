//
//  BeaconStore.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 3/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface BeaconStore : NSObject{
    NSMutableArray *allBeacons;
}
+(BeaconStore*)sharedStore;
-(NSArray*)allBeacons;
-(CLBeacon*)addNewBeacon:(CLBeacon*)b;
@property (nonatomic, strong) NSMutableArray *foundBeacons;
@end
