//
//  ViewController.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/8/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUIDStore.h"
#import "TableViewController.h"
#import "UUIDString.h"

@import CoreBluetooth;

@interface ViewController : UIViewController <CBCentralManagerDelegate, UITableViewDelegate>
{
    TableViewController *tableVC;
    UUIDString *newString;
}
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *peripheralData;
@property (strong, nonatomic) IBOutlet UITextField *UUIDTextField;
- (IBAction)TrackBeaconButtonPress:(id)sender;

@end
