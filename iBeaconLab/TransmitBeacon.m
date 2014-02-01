//
//  TransmitBeacon.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/8/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import "TransmitBeacon.h"

@interface TransmitBeacon ()
@property (nonatomic, readonly, strong) NSUUID *myUUID;
@end

@implementation TransmitBeacon

@synthesize TransmitIdentityLabel, TransmitUUIDLabel, MajorLabel, MinorLabel, beaconRegion, beaconPeripheralData, peripheralManager;


- (IBAction)transmitButtonPressed:(id)sender {
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil options:nil];
}

-(void)startTransmitting{
    _myUUID = [[UIDevice currentDevice]identifierForVendor];
    
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:_myUUID major:1 minor:1 identifier:[[UIDevice currentDevice]name]];
    
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil options:nil];
    [self setLabels];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"peripheral manager did updatestate");
    if(peripheral.state == CBPeripheralManagerStatePoweredOn){
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff){
        [self.peripheralManager stopAdvertising];
    }
}

-(void)setLabels{
    NSLog(@"set labels called");
    self.MajorLabel.text = [NSString stringWithFormat:@"%@", self.beaconRegion.major];
    self.MinorLabel.text = [NSString stringWithFormat:@"%@", self.beaconRegion.minor];
    self.TransmitUUIDLabel.text = self.beaconRegion.proximityUUID.UUIDString;
    self.TransmitIdentityLabel.text = self.beaconRegion.identifier;
    NSLog(@"transmit major %@", self.MajorLabel.text);
}

@end