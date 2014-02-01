//
//  TransmitBeacon.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/8/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>


@interface TransmitBeacon : NSObject <CBPeripheralManagerDelegate>

@property (strong, nonatomic) UILabel *MajorLabel;
@property (strong, nonatomic) UILabel *MinorLabel;
@property (strong, nonatomic) UILabel *TransmitUUIDLabel;
@property (strong, nonatomic) UILabel *TransmitIdentityLabel;

@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) NSDictionary *beaconPeripheralData;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

- (IBAction)transmitButtonPressed:(id)sender;
-(void)startTransmitting;
@end
