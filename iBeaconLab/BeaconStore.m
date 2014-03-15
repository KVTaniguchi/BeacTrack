//
//  BeaconStore.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 3/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "BeaconStore.h"

@implementation BeaconStore
+(BeaconStore*)sharedStore{
    BeaconStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedStore];
}

-(NSArray*)allBeacons{
    return allBeacons;
}

-(CLBeacon*)addNewBeacon:(CLBeacon*)b{
    [allBeacons addObject:b];
    return b;
}

@end
