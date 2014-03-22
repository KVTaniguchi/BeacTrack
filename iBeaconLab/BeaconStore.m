//
//  BeaconStore.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 3/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "BeaconStore.h"

@implementation BeaconStore
@synthesize context;
+(BeaconStore*)sharedStore{
    BeaconStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}

-(id)init{
    self = [super init];
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason is: %@", error.localizedDescription];
        }
        context = [[NSManagedObjectContext alloc]init];
        [context setPersistentStoreCoordinator:psc];
        [context setUndoManager:nil];
        allBeacons = [[NSMutableArray alloc]init];
        [self loadAllBeacons];
    }
    return self;
}

-(NSString*)itemArchivePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingString:@"storeBeacon.data"];
}

-(void)loadAllBeacons{
    if (!allBeacons) {
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSEntityDescription *e = [[model entitiesByName]objectForKey:@"Beacon"];
        [request setEntity:e];
        NSError *error;
        NSArray *beaconResult = [context executeFetchRequest:request error:&error];
        if (!beaconResult) {
            [NSException raise:@"Fetch failed" format:@"Reason is: %@", [error localizedDescription]];
        }
        allBeacons = [[NSMutableArray alloc]initWithArray:beaconResult];
    }
}

-(Beacon*)fetchBeaconWithUUID:(NSString*)uuidString{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Beacon"inManagedObjectContext:[BeaconStore sharedStore].context];
    [request setEntity:entity];
    NSPredicate *predicateUUIDString = [NSPredicate predicateWithFormat:@"beaconUUIDString = %@", uuidString];
    [request setPredicate:predicateUUIDString];
    NSError *error;
    NSArray *fetchedBeacons = [[BeaconStore sharedStore].context executeFetchRequest:request error:&error];
    if ([fetchedBeacons count] < 1) {
        NSLog(@"no beacons to fetch");
        return nil;
    }else{
        Beacon *fetchedBeacon = [fetchedBeacons objectAtIndex:0];
        return fetchedBeacon;
    }
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedStore];
}

-(NSArray*)allBeacons{
    return allBeacons;
}

-(void)clearAllBeacons{
    [allBeacons removeAllObjects];
}

-(Beacon*)addNewBeaconWithUUID:(NSString*)uuidString andRSSI:(NSUInteger)rssi{
    Beacon *b = [NSEntityDescription insertNewObjectForEntityForName:@"Beacon" inManagedObjectContext:context];
    b.beaconUUIDString = uuidString;
    NSNumber *n = [NSNumber numberWithUnsignedInteger:rssi];
    b.rssi = n;
    [allBeacons addObject:b];
    NSLog(@"added new beacon to core data: %@", b.description);
    return b;
}

@end
