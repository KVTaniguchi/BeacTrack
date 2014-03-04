//
//  MainViewController.m
//  iBeaconLab
//  Created by Kevin Taniguchi on 1/29/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.

#import "MainViewController.h"

static NSString *UUIDADVERT = @"D0548F44-7170-4BAA-AFDA-7F82076E6A25";

@implementation MainViewController{
    dispatch_queue_t backgroundQueue;
    CBPeripheralManager *peripheralManager;
    NSDictionary *beaconPeripheralData;
    BOOL isTransmitting;
}

@synthesize beaconRegion, locationManager, centralManager, UUIDToPass, foundBeacon,beaconStatusLabel,findingBeacon, transmitDistanceLabel, data, chatWithMCButton;

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    self.transmitDistanceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.broadcastIdentityLabel setHidden:YES];
    drawingView = [[DrawingView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    [self.view addSubview:drawingView];
    self.beaconStatusLabel.text = @"Looking for beacons...";
    self.data = [[NSMutableData alloc]init];
    [self.navigationController setNavigationBarHidden:NO];
    [self.chatWithMCButton setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    backgroundQueue = dispatch_queue_create("startTransmitting", NULL);
    dispatch_async(backgroundQueue, ^(void){
        [self startTransmitter];
    });
    [self glowEffect:beaconStatusLabel.layer withRect:beaconStatusLabel.frame];
}

// look for services that match MY transfer service UUID - in other words other versions of this same app
// call this method when the user agrees to connect with the discovered other transfer UUID 
- (IBAction)rangeBeacon:(id)sender {
    [self startiBeaconConfirmerWithUUIDString:UUIDADVERT];
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
    NSLog(@"Found %lu beacons", (unsigned long)[beacons count]);
    // possibly put these beacons in an array around you
    if (self.foundBeacon != NULL) {
        [self.chatWithMCButton setHidden:NO];
        [self.beaconStatusLabel.layer removeAllAnimations];
        self.beaconStatusLabel.text = [NSString stringWithFormat:@"Found Beacon"];
        NSLog(@"%@", self.foundBeacon.description);
        [self.transmitDistanceLabel setHidden:NO];
        if(self.foundBeacon.proximity == CLProximityUnknown){
            self.transmitDistanceLabel.text = @"unknown";
        } else if (self.foundBeacon.proximity == CLProximityImmediate){
            self.transmitDistanceLabel.text = @"immediate";
            [self.chatWithMCButton setHidden:NO];
            // kick off MCPeer Connection
        } else if (self.foundBeacon.proximity == CLProximityNear){
            self.transmitDistanceLabel.text = @"near";
            [self.chatWithMCButton setHidden:NO];
        } else if (self.foundBeacon.proximity == CLProximityFar){
            self.transmitDistanceLabel.text = @"far";
        }
        NSUInteger posRSSI = ABS(self.foundBeacon.rssi);
        if (posRSSI ==  0) {
            self.beaconStatusLabel.text = @"Signal Lost";
        }
        else if(self.foundBeacon != NULL){
            NSLog(@"RSS value is: %ld", (long)posRSSI);
            drawingView.circleRadius = 5000 / posRSSI;
            CGRect drawingRect = CGRectMake(0, 300, self.view.frame.size.width, 300);
            [self glowEffect:drawingView.layer withRect:drawingRect];
            [drawingView setNeedsDisplay];
        }
    }
    else if(self.foundBeacon == NULL){
        NSLog(@"did not find a beacon");
        self.beaconStatusLabel.text = @"Looking for Beacons";
        [self glowEffect:beaconStatusLabel.layer withRect:beaconStatusLabel.frame];
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
// TRANSMITTING A SIGNAL
-(void)startTransmitter{
    NSUUID *advertisingUUID = [[NSUUID alloc]initWithUUIDString:UUIDADVERT];
    // generate random numbers for the minor
    CLBeaconRegion *myBeaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:advertisingUUID major:1 minor:2 identifier:[[UIDevice currentDevice]name]];
    peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    beaconPeripheralData = [[NSDictionary alloc]init];
    beaconPeripheralData = [myBeaconRegion peripheralDataWithMeasuredPower:nil];
    self.broadcastIdentityLabel.text = [NSString stringWithFormat:@"%@",myBeaconRegion.identifier];
    [self.broadcastIdentityLabel setHidden:NO];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"peripheral manager did update state VC");
    if(peripheral.state == CBPeripheralManagerStatePoweredOn){
        [peripheralManager startAdvertising:beaconPeripheralData];
        NSLog(@"peripheral manager started advertising");
        [self.broadcastIdentityLabel setHidden:NO];
    }
    else if(peripheral.state == CBPeripheralManagerStatePoweredOff){
        [peripheralManager stopAdvertising];
        [self.broadcastIdentityLabel setHidden:YES];
    }
}

-(void)preferredContentSizeChanged:(NSNotification*)notification{
    self.transmitDistanceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (IBAction)chatWithMCButtonPressed:(id)sender {
    MCViewController *MCChatVC = [[MCViewController alloc]init];
    [drawingView removeFromSuperview];
    [self.navigationController pushViewController:MCChatVC animated:YES];
}
@end
