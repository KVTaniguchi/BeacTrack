//
//  Beacon.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 3/21/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Beacon : NSManagedObject

@property (nonatomic, retain) NSString * beaconUUIDString;
@property (nonatomic, retain) NSNumber * rssi;

@end
