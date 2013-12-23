//
//  UUIDString.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/20/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import "UUIDString.h"

@implementation UUIDString

@synthesize isABeacon, text;

-(id)init{
    self = [super init];
    
    isABeacon = NO;
    
    self.text = nil;
    
    return self;
}

@end
