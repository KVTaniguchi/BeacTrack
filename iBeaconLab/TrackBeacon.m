//
//  TrackBeacon.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/8/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

/*
    
 new stragety - register known devices as beacons?

*/

#import "TrackBeacon.h"

@interface TrackBeacon ()
{
//    NSMutableArray *peripheralUUIDsArray;
//    NSMutableArray *peripheralNamesArray;
//    NSString *nullName;
//    NSSet *setOfUniquePeripheralUUIDs;
//    NSSet *setOfUniquePeripheralNames;
//    NSUUID *peripheralUUID;
//    CLBeaconRegion *regionToCheck;
//    NSMutableArray *beaconsFound;
}
@end

@implementation TrackBeacon

@synthesize beaconRegion, beaconFoundLabel, proxUUIDLabel, transmitAccuracyLabel, transmitMinorLabel,transmitDistanceLabel, transmitMajorLabel, transmitRSSILabel, locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    peripheralUUIDsArray = [NSMutableArray arrayWithObjects:nil];
//    peripheralNamesArray = [NSMutableArray arrayWithObjects:nil];
//    centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self initRegion];
    
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
}

-(void)initRegion{
    
    NSLog(@"Init region called");
    NSUUID *u = [[NSUUID alloc]initWithUUIDString:@"77D65832-5F60-4423-837A-13868B97AB35"];
    
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:u major:1 minor:1 identifier:@"Front AAVAA"];
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"Did start monitoring regions");
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Did enter region Called");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    self.beaconFoundLabel.text = @"No";
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    NSLog(@"Location Manager found %lu beacons", (unsigned long)[beacons count]);
    NSLog(@"%@", beacons.description);
    
    CLBeacon *beacon = [[CLBeacon alloc]init];
    beacon = [beacons lastObject];
    
    self.beaconFoundLabel.text = @"Yes";
    self.proxUUIDLabel.text = beacon.proximityUUID.UUIDString;
    self.transmitMajorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    self.transmitMinorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    self.transmitAccuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
    if(beacon.proximity == CLProximityUnknown){
        self.transmitDistanceLabel.text = @"Proximity unknown";
    } else if (beacon.proximity == CLProximityImmediate){
        self.transmitDistanceLabel.text = @"Proximity immediate";
    } else if (beacon.proximity == CLProximityNear){
        self.transmitDistanceLabel.text = @"Proximity near";
    } else if (beacon.proximity == CLProximityFar){
        self.transmitDistanceLabel.text = @"Proximity far";
    }
    self.transmitRSSILabel.text = [NSString stringWithFormat:@"%li", (long)beacon.rssi];
    
    [self.locationManager stopMonitoringForRegion:region];
//    [centralManager stopScan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
//    
//    if (centralManager.state == CBCentralManagerStatePoweredOn) {
//        NSLog(@"Core bluetooth powered on");
//    }
//    else {
//        return;
//    }
//    if(centralManager){
//        NSLog(@"central manager created");
//    }
//    [centralManager scanForPeripheralsWithServices:nil options:nil];
//}

// UUID collection CoreBlueTooth ZONE

//
//-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
//    
//    NSLog(@"Found peripherial with UUID: %@ and name: %@",[NSString stringWithFormat:@"%@", peripheral.identifier.UUIDString], peripheral.name);
//    if (peripheral.name == NULL) {
//        nullName = [NSString stringWithFormat:@"%@",peripheral.identifier.UUIDString];
//        [peripheralNamesArray addObject:nullName];
//    }
//    else {
//        [peripheralNamesArray addObject:peripheral.name];
//    }
//    
//    [peripheralUUIDsArray addObject:peripheral.identifier];
//    
//    NSUUID *u = [[NSUUID alloc]initWithUUIDString:@"E53D9064-5386-4624-8536-6A50FDAEED84"];
//    
//    beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:u major:1 minor:1 identifier:@"AirLocate"];
//    
//    [self.locationManager startMonitoringForRegion:beaconRegion];
//    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
//
//    
//    double delayInSeconds = 20.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        //code to be executed on the main queue after dela
//        
//        NSLog(@"Stopping scan to check found objects as beacons, peri array has: %lu", (unsigned long)[peripheralUUIDsArray count]);
//        
//        setOfUniquePeripheralUUIDs = [NSSet setWithArray:peripheralUUIDsArray];
//        setOfUniquePeripheralNames = [NSSet setWithArray:peripheralNamesArray];
//        [self checkPeripherals];
//        return ;
//    });
//
//}

//-(void)checkPeripherals{
//    [self.centralManager stopScan];
//    [centralManager stopScan];
//    NSLog(@"checkperipherals called");
//    
//    NSLog(@"UUIDSet has %lu", (unsigned long)[setOfUniquePeripheralUUIDs count]);
//    NSLog(@"NameSet has %lu", (unsigned long)[setOfUniquePeripheralNames count]);
//    
//    NSMutableArray *a = [NSMutableArray arrayWithArray:[setOfUniquePeripheralUUIDs allObjects]];
//    NSMutableArray *b = [NSMutableArray arrayWithArray:[setOfUniquePeripheralNames allObjects]];
//    
//    NSLog(@"uuids array: %lu names array : %lu", (unsigned long)[a count], (unsigned long)[b count]);
//
//    NSLog(@"uuids array: %@ names array : %@", a.debugDescription, b.debugDescription);
//}

/// BEACON ZONE

@end
