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
#import "TableViewController.h"
#import "PeripheralStore.h"
#import "UUIDString.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate, UITableViewDelegate>
{
    NSString *newUUIDString;
    CBPeripheral *newPeripheral;
    NSUUID *grabbedUUID;
    NSMutableSet *setOfUniquePeriperals;
    DrawingView *drawingView;
    TableViewController *tvc;
}
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSString *UUIDToPass;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeacon *foundBeacon;

-(void)startiBeaconConfirmerWithUUIDString:(NSString*)passedInUUIDString;
@property BOOL findingBeacon;

-(void)glowEffect:(CALayer*)layer withRect:(CGRect)rect;
@property (strong, nonatomic) IBOutlet UILabel *beaconStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *retrievedUUIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *retrievedbroadcastMajorLabel;
@property (strong, nonatomic) IBOutlet UILabel *retrievedbroadcastMinorLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmitDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *retrievedRSSILabel;

@property (strong, nonatomic) IBOutlet UILabel *broadcastMajorLabel;
@property (strong, nonatomic) IBOutlet UILabel *broadcastMinorLabel;
@property (strong, nonatomic) IBOutlet UILabel *broadcastUUIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *broadcastIdentityLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmittingAsLabel;

@end
