//
//  MainViewController.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 1/29/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <QuartzCore/QuartzCore.h>
#import "DrawingView.h"
#import "TransmitBeacon.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate>
{
    NSString *newUUIDString;
    CBPeripheral *newPeripheral;
    NSUUID *grabbedUUID;
    NSMutableSet *setOfUniquePeriperals;
    DrawingView *drawingView;
}
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSString *UUIDToPass;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeacon *foundBeacon;

-(void)startiBeaconConfirmerWithUUIDString:(NSString*)passedInUUIDString;
@property (strong, nonatomic) IBOutlet UILabel *beaconStatusLabel;
@property BOOL findingBeacon;

-(void)glowEffect:(CALayer*)layer withRect:(CGRect)rect;

@property (strong, nonatomic) IBOutlet UILabel *proxUUIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmitMajorLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmitMinorLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmitDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmitRSSILabel;

@property (strong, nonatomic) IBOutlet UILabel *MajorLabel;
@property (strong, nonatomic) IBOutlet UILabel *MinorLabel;
@property (strong, nonatomic) IBOutlet UILabel *TransmitUUIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *TransmitIdentityLabel;

@end
