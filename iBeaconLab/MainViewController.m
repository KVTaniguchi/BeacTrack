//
//  MainViewController.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 1/29/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController{
    dispatch_queue_t backgroundQueue;
    CBPeripheralManager *peripheralManager;
    NSDictionary *beaconPeripheralData;
}

@synthesize beaconRegion, locationManager, centralManager, discoveredPeripheral, UUIDToPass, foundBeacon,beaconStatusLabel,findingBeacon, proxUUIDLabel, transmitDistanceLabel, transmitMajorLabel,transmitMinorLabel, transmitRSSILabel;

-(id)init{
    self = [super init];
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.transmitDistanceLabel setHidden:YES];
    [self.transmitRSSILabel setHidden:YES];
    [self.proxUUIDLabel setHidden:YES];
    [self.transmitMajorLabel setHidden:YES];
    [self.transmitMinorLabel setHidden:YES];
    self.transmitMinorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitMajorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitRSSILabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.proxUUIDLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    self.transmitDistanceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    drawingView = [[DrawingView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 300)];
    [self.view addSubview:drawingView];
    self.beaconStatusLabel.text = @"Looking for beacons...";
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
    backgroundQueue = dispatch_queue_create("startTransmitting", NULL);
    dispatch_async(backgroundQueue, ^(void){
        [self startTransmitter];
    });
    
}

-(void)startTransmitter{
    NSUUID *deviceUUID = [[UIDevice currentDevice]identifierForVendor];
    CLBeaconRegion *myBeaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:deviceUUID major:1 minor:1 identifier:@"Your Device"];
    peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    beaconPeripheralData = [[NSDictionary alloc]init];
    beaconPeripheralData = [myBeaconRegion peripheralDataWithMeasuredPower:nil];
    
    self.MajorLabel.text = [NSString stringWithFormat:@"%@",myBeaconRegion.major ];
    self.MinorLabel.text = [NSString stringWithFormat:@"%@",myBeaconRegion.minor];
    
    self.TransmitUUIDLabel.text = [NSString stringWithFormat:@"%@",deviceUUID.UUIDString];
    self.TransmitIdentityLabel.text = [NSString stringWithFormat:@"%@",myBeaconRegion.identifier];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"peripheral manager did update state VC");
    if(peripheral.state == CBPeripheralManagerStatePoweredOn){
        [peripheralManager startAdvertising:beaconPeripheralData];
    }
    else if(peripheral.state == CBPeripheralManagerStatePoweredOff){
        [peripheralManager stopAdvertising];
    }
}

-(void)preferredContentSizeChanged:(NSNotification*)notification{
    self.transmitMinorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitMajorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitRSSILabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.proxUUIDLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
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
        [self startiBeaconConfirmerWithUUIDString:peripheral.identifier.UUIDString];
        [self.centralManager stopScan];
        // call the beaconConfirmer here using peripheral uuid
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
        // add code to act on the beacon
        // add code to call method to draw circle based on RSS value of beacon
        
        [self.transmitDistanceLabel setHidden:NO];
        [self.transmitRSSILabel setHidden:NO];
        [self.proxUUIDLabel setHidden:NO];
        [self.transmitMajorLabel setHidden:NO];
        [self.transmitMinorLabel setHidden:NO];

        
        NSString *idString = self.foundBeacon.proximityUUID.UUIDString;
        NSString *beaconUUID = [idString substringFromIndex:([idString length]-4)];
        self.proxUUIDLabel.text = beaconUUID;
        self.transmitMajorLabel.text = [NSString stringWithFormat:@"%@", self.foundBeacon.major];
        self.transmitMinorLabel.text = [NSString stringWithFormat:@"%@", self.foundBeacon.minor];
        if(self.foundBeacon.proximity == CLProximityUnknown){
            self.transmitDistanceLabel.text = @"unknown";
        } else if (self.foundBeacon.proximity == CLProximityImmediate){
            self.transmitDistanceLabel.text = @"immediate";
        } else if (self.foundBeacon.proximity == CLProximityNear){
            self.transmitDistanceLabel.text = @"near";
        } else if (self.foundBeacon.proximity == CLProximityFar){
            self.transmitDistanceLabel.text = @"far";
        }
        self.transmitRSSILabel.text = [NSString stringWithFormat:@"%li", (long)self.foundBeacon.rssi];
        
        NSUInteger posRSSI = ABS(self.foundBeacon.rssi);
        if (posRSSI ==  0) {
            self.beaconStatusLabel.text = @"Signal Lost";
        }
        NSLog(@"RSS value is: %ld", (long)posRSSI);
        drawingView.circleRadius = 3500 / posRSSI;
        CGRect drawingRect = CGRectMake(0, 300, self.view.frame.size.width, 300);
        [self glowEffect:drawingView.layer withRect:drawingRect];
        [drawingView setNeedsDisplay];
    }
    else if(self.foundBeacon == NULL){
        NSLog(@"did not find a beacon");
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        self.beaconStatusLabel.text = @"Looking for Beacons";
        CGRect drawingRect = CGRectMake(0, 300, self.view.frame.size.width, 300);
        [self glowEffect:beaconStatusLabel.layer withRect:drawingRect];
        [self.transmitDistanceLabel setHidden:YES];
        [self.transmitRSSILabel setHidden:YES];
        [self.proxUUIDLabel setHidden:YES];
        [self.transmitMajorLabel setHidden:YES];
        [self.transmitMinorLabel setHidden:YES];
    }
}

-(void)glowEffect:(CALayer*)layer withRect:(CGRect)rect{
    CABasicAnimation *glowEffect;
    glowEffect = [CABasicAnimation animationWithKeyPath:@"opacity"];
    glowEffect.duration = 1.0;
    glowEffect.repeatCount = HUGE_VALF;
    glowEffect.autoreverses = NO;
    glowEffect.fromValue = [NSNumber numberWithFloat:0.6];
    glowEffect.toValue = [NSNumber numberWithFloat:0.5];
    [layer addAnimation:glowEffect forKey:@"animateOpacity"];
    [self.view setNeedsDisplay];
}

@end
