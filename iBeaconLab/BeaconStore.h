//
//  BeaconStore.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 3/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import CoreData;
#import "Beacon.h"

@interface BeaconStore : NSObject{
    NSMutableArray *allBeacons;
    NSManagedObjectModel *model;
}
+(BeaconStore*)sharedStore;
-(NSArray*)allBeacons;
-(void)loadAllBeacons;
-(Beacon*)addNewBeaconWithUUID:(NSString*)uuidString andRSSI:(NSUInteger)rssi;
-(NSString*)itemArchivePath;
-(void)clearAllBeacons;
-(Beacon*)fetchBeaconWithUUID:(NSString*)uuidString;
@property (nonatomic, strong) NSMutableArray *foundBeacons;
@property (nonatomic, strong) NSManagedObjectContext *context;
@end
