//
//  UUIDStore.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/19/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUIDString.h"

@interface UUIDStore : NSObject
{
    NSMutableSet *allUUIDsSet;
}

+(UUIDStore*)sharedStore;
-(NSMutableSet*)allUUIDsSet;
-(UUIDString*)createNewUUIDstring;
@end
