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
        allUUIDsSet = [[NSMutableSet alloc]init];
    }
    return self;
}

-(UUIDString*)createNewUUIDstring{
    UUIDString *s = [[UUIDString alloc]init];
    
    [allUUIDsSet addObject:s];
    
    return s;
}


-(NSSet*)allUUIDsSet{
    return allUUIDsSet;
}
@end
