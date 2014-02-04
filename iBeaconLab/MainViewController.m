//
//  MainViewController.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 1/29/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//  TO DO
//  put in a textfield for entering UUIDs to range
//  when done editing startRanging with that UUID that makes that beaconRegion

#import "MainViewController.h"

@implementation MainViewController{
    dispatch_queue_t backgroundQueue;
    CBPeripheralManager *peripheralManager;
    NSDictionary *beaconPeripheralData;
    BOOL isTransmitting;
}

@synthesize beaconRegion, locationManager, centralManager, discoveredPeripheral, UUIDToPass, foundBeacon,beaconStatusLabel,findingBeacon, retrievedUUIDLabel, transmitDistanceLabel, retrievedbroadcastMajorLabel,retrievedbroadcastMinorLabel, retrievedRSSILabel, transmittingAsLabel;

-(void)viewWillAppear:(BOOL)animated{
    tvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"PeripheralTableView"];
    [tvc.view setFrame:CGRectMake(171, 50, 142, 163)];
    [self addChildViewController:tvc];
    [self.view addSubview:tvc.view];
    [tvc.tableView setDelegate:self];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self.retrievedUUIDLabel setHidden:YES];
    [self.retrievedbroadcastMajorLabel setHidden:YES];
    [self.retrievedbroadcastMinorLabel setHidden:YES];
    [self.transmittingAsLabel setHidden:YES];
    self.retrievedbroadcastMinorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.retrievedbroadcastMajorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.retrievedRSSILabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.retrievedUUIDLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    self.transmitDistanceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.broadcastMajorLabel setHidden:YES];
    [self.broadcastMinorLabel setHidden:YES];
    [self.broadcastUUIDLabel setHidden:YES];
    [self.broadcastIdentityLabel setHidden:YES];
    [self.transmittingAsLabel setHidden:YES];
    drawingView = [[DrawingView alloc]initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 300)];
    [self.view addSubview:drawingView];
    self.beaconStatusLabel.text = @"Looking for beacons...";
}

-(void)viewDidAppear:(BOOL)animated{
    backgroundQueue = dispatch_queue_create("startTransmitting", NULL);
    dispatch_async(backgroundQueue, ^(void){
        [self startTransmitter];
    });
    [self glowEffect:beaconStatusLabel.layer withRect:beaconStatusLabel.frame];
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

-(void)startTransmitter{
    NSUUID *deviceUUID = [[UIDevice currentDevice]identifierForVendor];
    
    CLBeaconRegion *myBeaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:deviceUUID major:1 minor:1 identifier:[[UIDevice currentDevice]name]];
    peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    beaconPeripheralData = [[NSDictionary alloc]init];
    beaconPeripheralData = [myBeaconRegion peripheralDataWithMeasuredPower:nil];
    NSString *peripheralUUIDString = [NSString stringWithFormat:@"%@", deviceUUID.UUIDString];
    NSString *shorterString = [peripheralUUIDString substringFromIndex:([peripheralUUIDString length]-4)];
    self.broadcastMajorLabel.text = [NSString stringWithFormat:@"%@",myBeaconRegion.major];
    self.broadcastMinorLabel.text = [NSString stringWithFormat:@"%@",myBeaconRegion.minor];
    self.broadcastUUIDLabel.text = [NSString stringWithFormat:@"%@",shorterString];
    self.broadcastIdentityLabel.text = [NSString stringWithFormat:@"%@",myBeaconRegion.identifier];
    self.transmittingAsLabel.text = [NSString stringWithFormat:@"Transmitting"];
    [self.broadcastMajorLabel setHidden:NO];
    [self.broadcastMinorLabel setHidden:NO];
    [self.broadcastUUIDLabel setHidden:NO];
    [self.broadcastIdentityLabel setHidden:NO];
    [self.transmittingAsLabel setHidden:YES];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"peripheral manager did update state VC");
    if(peripheral.state == CBPeripheralManagerStatePoweredOn){
        [peripheralManager startAdvertising:beaconPeripheralData];
        NSLog(@"peripheral manager started advertising");
        [self.broadcastMajorLabel setHidden:NO];
        [self.broadcastMinorLabel setHidden:NO];
        [self.broadcastUUIDLabel setHidden:NO];
        [self.broadcastIdentityLabel setHidden:NO];
        [self.transmittingAsLabel setHidden:NO];
    }
    else if(peripheral.state == CBPeripheralManagerStatePoweredOff){
        [peripheralManager stopAdvertising];
        [self.broadcastMajorLabel setHidden:YES];
        [self.broadcastMinorLabel setHidden:YES];
        [self.broadcastUUIDLabel setHidden:YES];
        [self.broadcastIdentityLabel setHidden:YES];
    }
}

-(void)preferredContentSizeChanged:(NSNotification*)notification{
    self.retrievedbroadcastMinorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.retrievedbroadcastMajorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.retrievedRSSILabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.retrievedUUIDLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    self.transmitDistanceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"central manager powered on");
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    else return;
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"Found a peripheral: %@", peripheral.description);
    if (![setOfUniquePeriperals containsObject:peripheral]) {
        NSLog(@"Added Unique Peripheral: %@", peripheral.description);
        [setOfUniquePeriperals addObject:peripheral];
        // add to the peripheralStore
        [[PeripheralStore sharedStore]addNewPeripheral:peripheral];
        NSLog(@"Peri store has:  %lu", (unsigned long)[[[PeripheralStore sharedStore]allPeripheralsSet] count]);
        [tvc.tableView reloadData];
        [self startiBeaconConfirmerWithUUIDString:peripheral.identifier.UUIDString];
        [self.centralManager stopScan];
    }
}

-(void)startiBeaconConfirmerWithUUIDString:(NSString *)passedInUUIDString{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    NSUUID *uuidToPass = [[NSUUID alloc]initWithUUIDString:passedInUUIDString];
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:uuidToPass identifier:@"asdfasdf"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    });
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"ERROR: %@", error.description);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"locationManager did start monitoring");
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"did enter region called");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    //return the beaconFound propreeties
    NSLog(@"did range beacons called");
    self.foundBeacon = [[CLBeacon alloc]init];
    self.foundBeacon = [beacons lastObject];
    if (self.foundBeacon != NULL) {
        [self.beaconStatusLabel.layer removeAllAnimations];
        self.beaconStatusLabel.text = @"Found A Beacon";
        [self.transmitDistanceLabel setHidden:NO];
        [self.retrievedRSSILabel setHidden:NO];
        [self.retrievedUUIDLabel setHidden:NO];
        [self.retrievedbroadcastMajorLabel setHidden:NO];
        [self.retrievedbroadcastMinorLabel setHidden:NO];

        NSString *idString = self.foundBeacon.proximityUUID.UUIDString;
        NSString *beaconUUID = [idString substringFromIndex:([idString length]-4)];
        self.retrievedUUIDLabel.text = beaconUUID;
        self.retrievedbroadcastMajorLabel.text = [NSString stringWithFormat:@"%@", self.foundBeacon.major];
        self.retrievedbroadcastMinorLabel.text = [NSString stringWithFormat:@"%@", self.foundBeacon.minor];
        if(self.foundBeacon.proximity == CLProximityUnknown){
            self.transmitDistanceLabel.text = @"unknown";
        } else if (self.foundBeacon.proximity == CLProximityImmediate){
            self.transmitDistanceLabel.text = @"immediate";
        } else if (self.foundBeacon.proximity == CLProximityNear){
            self.transmitDistanceLabel.text = @"near";
        } else if (self.foundBeacon.proximity == CLProximityFar){
            self.transmitDistanceLabel.text = @"far";
        }
        self.retrievedRSSILabel.text = [NSString stringWithFormat:@"%li", (long)self.foundBeacon.rssi];
        
        NSUInteger posRSSI = ABS(self.foundBeacon.rssi);
        if (posRSSI ==  0) {
            self.beaconStatusLabel.text = @"Signal Lost";
        }
        NSLog(@"RSS value is: %ld", (long)posRSSI);
        drawingView.circleRadius = 3800 / posRSSI;
        CGRect drawingRect = CGRectMake(0, 300, self.view.frame.size.width, 300);
        [self glowEffect:drawingView.layer withRect:drawingRect];
        [drawingView setNeedsDisplay];
    }
    else if(self.foundBeacon == NULL){
        NSLog(@"did not find a beacon");
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        self.beaconStatusLabel.text = @"Looking for Beacons";
        [self glowEffect:beaconStatusLabel.layer withRect:beaconStatusLabel.frame];
        [self.transmitDistanceLabel setHidden:YES];
        [self.retrievedRSSILabel setHidden:YES];
        [self.retrievedUUIDLabel setHidden:YES];
        [self.retrievedbroadcastMajorLabel setHidden:YES];
        [self.retrievedbroadcastMinorLabel setHidden:YES];
    }
}

-(void)glowEffect:(CALayer*)layer withRect:(CGRect)rect{
    CABasicAnimation *glowEffect;
    glowEffect = [CABasicAnimation animationWithKeyPath:@"opacity"];
    glowEffect.duration = 1.0;
    glowEffect.repeatCount = HUGE_VALF;
    glowEffect.autoreverses = NO;
    glowEffect.fromValue = [NSNumber numberWithFloat:0.25];
    glowEffect.toValue = [NSNumber numberWithFloat:0.685];
    [layer addAnimation:glowEffect forKey:@"animateOpacity"];
    [self.view setNeedsDisplay];
}


@end
