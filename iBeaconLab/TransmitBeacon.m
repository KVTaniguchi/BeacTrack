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

-(void)initBeacon{
    
    _myUUID = [[UIDevice currentDevice]identifierForVendor];
    
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:_myUUID major:1 minor:1 identifier:@"com.Taniguchi.myRegion"];
    
    NSLog(@"my uuid is: %@",_myUUID.UUIDString);
    
}

- (IBAction)transmitButtonPressed:(id)sender {
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil options:nil];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if(peripheral.state == CBPeripheralManagerStatePoweredOn){
        NSLog(@"Powered On");
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff){
        NSLog(@"Powered Off");
        [self.peripheralManager stopAdvertising];
    }
}

-(void)setLabels{
    MajorLabel.text = [NSString stringWithFormat:@"%@", self.beaconRegion.major];
    MinorLabel.text = [NSString stringWithFormat:@"%@", self.beaconRegion.minor];
    TransmitUUIDLabel.text = self.beaconRegion.proximityUUID.UUIDString;
    TransmitIdentityLabel.text = self.beaconRegion.identifier;
}

//////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initBeacon];
    [self setLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end