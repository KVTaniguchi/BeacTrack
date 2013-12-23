//
//  TrackBeacon.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/8/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@import QuartzCore;

@interface TrackBeacon : UIViewController <CLLocationManagerDelegate> //CBCentralManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *beaconFoundLabel;
@property (strong, nonatomic) IBOutlet UILabel *proxUUIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmitMajorLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmitMinorLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmitDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *transmitRSSILabel;


@property (strong, nonatomic) CLBeaconRegion *beaconRegion;    // define the beacons we're looking for
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *selectedUUID;

@end
