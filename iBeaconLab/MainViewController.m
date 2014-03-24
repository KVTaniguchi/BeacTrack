//
//  MainViewController.m
//  iBeaconLab
//  Created by Kevin Taniguchi on 1/29/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.

#import "MainViewController.h"

static NSString *UUIDADVERT = @"D0548F44-7170-4BAA-AFDA-7F82076E6A26";

@implementation MainViewController{
    dispatch_queue_t backgroundQueue;
    CBPeripheralManager *peripheralManager;
    NSDictionary *beaconPeripheralData;
    BOOL isTransmitting;
}

@synthesize  centralManager, UUIDToPass,beaconStatusLabel,findingBeacon, data, chatWithMCButton, banner, rssiLabel;

-(void)viewWillAppear:(BOOL)animated{
    self.banner = [[ADBannerView alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self.broadcastIdentityLabel setHidden:YES];
    drawingView = [[DrawingView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    self.beaconStatusLabel.text = @"Looking for beacons...";
    self.data = [[NSMutableData alloc]init];
    [self.navigationController setNavigationBarHidden:NO];
    [self.chatWithMCButton setHidden:YES];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isInRegion = NO;
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        //    static NSString *UUIDADVERT = @"D0548F44-7170-4BAA-AFDA-7F82076E6A25";
        //    static NSString *UUIDADVERT = @"A6AA4D3A-9A27-921B-5DA7-8E704FAA936A";  // from leDict.plist
        // UUID for snf device type ibeacon prox uuid: E558D748-E36D-46E9-8D71-AD6492173755
        // snf device id: A6AA4D3A-9A27-921B-5DA7-8E704FAA936A
        // mac beacon D0548F44-7170-4BAA-AFDA-7F82076E6A25
        //static NSString *UUIDADVERT = @"A6AA4D3A-9A27-921B-5DA7-8E704FAA936A";
        static NSString *UUIDADVERT = @"D0548F44-7170-4BAA-AFDA-7F82076E6A25";  // from value for device id
        NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:UUIDADVERT];
        self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:uuid major:1 minor:1 identifier:@"beacon"];
        self.beaconRegion.notifyEntryStateOnDisplay = NO;
        self.beaconRegion.notifyOnEntry = YES;
        self.beaconRegion.notifyOnExit = YES;
        [self.locationManager requestStateForRegion:self.beaconRegion];
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        collectedBeacons = [[NSMutableSet alloc]init];
    });
}

-(void)viewDidAppear:(BOOL)animated{
    backgroundQueue = dispatch_queue_create("startTransmitting", NULL);
    dispatch_async(backgroundQueue, ^(void){
        [self startTransmitter];
    });
    [self glowEffect:beaconStatusLabel.layer withRect:beaconStatusLabel.frame];
}

-(void)viewWillDisappear:(BOOL)animated{
    [drawingView removeFromSuperview];
    
}

-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    [drawingView removeFromSuperview];
}

-(void)_sendEnterLocalNotification{
    UILocalNotification *enterNotification = [[UILocalNotification alloc]init];
    enterNotification.alertBody = @"Inside Beacon Region";
    enterNotification.alertAction = @"Open";
    [[UIApplication sharedApplication]scheduleLocalNotification:enterNotification];
    _isInRegion = YES;
}

-(void)_sendExitLocalNotification{
    UILocalNotification *leaveNotification = [[UILocalNotification alloc]init];
    leaveNotification.alertBody = @"Left Beacon Region";
    leaveNotification.alertAction = @"Open";
    [[UIApplication sharedApplication]scheduleLocalNotification:leaveNotification];
    _isInRegion = NO;
}

-(void)_updateUIForState:(CLRegionState)state{
    if (state == CLRegionStateInside) {
    }
    else if (state == CLRegionStateOutside){
    }
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    [self _updateUIForState:state];
    if (state == CLRegionStateInside) {
        _isInRegion = YES;
        return;
    }
    else if (state == CLRegionStateOutside){
        _isInRegion = NO;
        return;
    }
}


-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    if ([beacons count] > 0) {
        CLBeacon *beacon = [beacons lastObject];
        [self.view addSubview:drawingView];
        if (![collectedBeacons containsObject:beacon.proximityUUID]) {
            newBeacon = [[BeaconStore sharedStore]addNewBeaconWithUUID:[NSString stringWithFormat:@"%@", beacon.proximityUUID] andRSSI:beacon.rssi];
            [collectedBeacons addObject:beacon.proximityUUID];
        }
        rssiFromBeaconStore = beacon.rssi;
        self.rssiLabel.text = [NSString stringWithFormat:@"%ld",(long)ABS(rssiFromBeaconStore)];
        [self setUpBeaconViewingData];
        _isInRegion = YES;
    }
    else{
        _isInRegion = NO;
    }
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"ERROR: %@", error.description);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"didd start monotring called: locationManager did start monitoring");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"did enter region called");
    _isInRegion = YES;
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self _sendEnterLocalNotification];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"did exit the region");
    _isInRegion = NO;
    [self _sendExitLocalNotification];
}

-(void)setUpBeaconViewingData{
    [self.chatWithMCButton setHidden:NO];
    [self.beaconStatusLabel.layer removeAllAnimations];
    self.beaconStatusLabel.text = [NSString stringWithFormat:@"Found Beacon"];
        NSInteger posRSSI = ABS(rssiFromBeaconStore);
        if (posRSSI ==  0) {
            self.beaconStatusLabel.text = @"Signal Lost";
            self.rssiLabel.text = [NSString stringWithFormat:@"%ld",(long)posRSSI];
            [drawingView removeFromSuperview];
            [self.chatWithMCButton setHidden:YES];
        }
        else if(rssiFromBeaconStore != 0){
            NSLog(@"RSS value is: %ld", (long)posRSSI);
            drawingView.circleRadius = 5000 / posRSSI;
            CGRect drawingRect = CGRectMake(0, 300, self.view.frame.size.width, 400);
            [self glowEffect:drawingView.layer withRect:drawingRect];
            [drawingView setNeedsDisplay];
            [self.chatWithMCButton setHidden:NO];
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
    self.broadcastIdentityLabel.text = [NSString stringWithFormat:@"Your Transmit ID: %@",myBeaconRegion.identifier];
    [self.broadcastIdentityLabel setHidden:NO];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
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

}

- (IBAction)chatWithMCButtonPressed:(id)sender {
    MCViewController *MCChatVC = [[MCViewController alloc]init];
    [drawingView setHidden:YES];
    [drawingView removeFromSuperview];
    [self.navigationController pushViewController:MCChatVC animated:YES];
}
@end
