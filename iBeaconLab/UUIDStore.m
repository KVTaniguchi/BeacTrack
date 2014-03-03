//
//  UUIDStore.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/19/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import "UUIDStore.h"

@implementation UUIDStore

+(UUIDStore*)sharedStore{
    
    static UUIDStore *sharedStore = nil;
    
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}

+(id)allocWithZone:(NSZone*)zone{
    return [self sharedStore];
}


-(id)init{
    self = [super init];
    if(self){
        allPeripheralsSet = [[NSMutableSet alloc]init];
    }
    return self;
}

-(UUIDString*)createNewUUIDstring{
    UUIDString *s = [[UUIDString alloc]init];       // stop calling this method to add UUIDString objects, call addNewPeripherals instead
    
    [allPeripheralsSet addObject:s];
    
    return s;
}

-(CBPeripheral*)addNewPeripheral:(CBPeripheral*)peripheral{
    
    [allPeripheralsSet addObject:peripheral];
    
    return peripheral;
}

-(NSSet*)allPeripheralsSet{
    return allPeripheralsSet;
}

@end
