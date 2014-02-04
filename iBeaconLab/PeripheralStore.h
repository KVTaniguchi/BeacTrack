//
//  PeripheralStore.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/19/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUIDString.h"
@import CoreBluetooth;

@interface PeripheralStore : NSObject
{
    NSMutableSet *allPeripheralsSet;
}

+(PeripheralStore*)sharedStore;
-(NSMutableSet*)allPeripheralsSet;
-(UUIDString*)createNewUUIDstring;
-(CBPeripheral*)addNewPeripheral:(CBPeripheral*)peripheral;
@end
