//
//  MainViewController.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 1/29/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <QuartzCore/QuartzCore.h>
#import "DrawingView.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "MCViewController.h"
#import "BeaconStore.h"
#import "Beacon.h"

@class MainViewController;
@protocol MainVCBeaconListenerDelegate <NSObject>

-(NSInteger)upDatedRSSI:(NSInteger)rssi;

@end

@interface MainViewController : UIViewController <CBPeripheralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate>
{
    NSString *newUUIDString;
    CBPeripheral *newPeripheral;
    NSUUID *grabbedUUID;
    NSMutableSet *setOfUniquePeriperals;
    DrawingView *drawingView;
    NSInteger rssiFromBeaconStore;
    Beacon *newBeacon;
    
    BOOL _isInRegion;
    NSMutableSet *collectedBeacons;
}

@property (strong, nonatomic) IBOutlet UILabel *rssiLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *rangingBeaconRegion;
@property (strong, nonatomic) CLBeaconRegion *transmitBeaconRegion;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSString *UUIDToPass;
@property (strong, nonatomic) NSMutableData *data;
@property BOOL findingBeacon;
@property (strong, nonatomic) IBOutlet UILabel *beaconStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *broadcastIdentityLabel;
-(void)glowEffect:(CALayer*)layer withRect:(CGRect)rect;
@property (strong, nonatomic) MCPeerID *myPeerID;
@property (strong, nonatomic) IBOutlet UIButton *chatWithMCButton;
- (IBAction)chatWithMCButtonPressed:(id)sender;
-(void)setUpBeaconViewingData;

@end
