//
//  ViewController.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/8/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import "ViewController.h"
#import "TrackBeacon.h"

@interface ViewController ()
{
    NSUUID *grabbedUUID;
    int grabbedUUIDindex;
    NSMutableArray *peripherals;  // grabbed periperals put in here
    NSMutableSet *setOfUniquePeriperals;
}
@end

@implementation ViewController

@synthesize centralManager, peripheralData, discoveredPeripheral;

- (void)viewDidLoad
{
    [super viewDidLoad];
    grabbedUUIDindex = 0;
    peripherals = [NSMutableArray arrayWithObjects:nil];
    setOfUniquePeriperals = [NSMutableSet setWithObjects:nil];
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    tableVC = [[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil];
    [tableVC.view setFrame:CGRectMake(0, 210, self.view.frame.size.width, 200)];
    [self addChildViewController:tableVC];
    [self.view addSubview:tableVC.view];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    self.UUIDTextField.text = nil;
}

-(void)reloadTable{
    [tableVC.tableView reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.UUIDTextField setText:tableVC.selectedUUID];
    [self.UUIDTextField resignFirstResponder];
}

- (IBAction)TrackBeaconButtonPress:(id)sender {
    [self.centralManager stopScan];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"pushTrackBeacon"]) {
        if ([self.UUIDTextField.text length]>1) {
            return YES;
        }
    }
    else if ([identifier isEqualToString:@"transmitSegue"]){
        return YES;
    }
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pushTrackBeacon"]) {
        if([_UUIDTextField.text length]< 2){
            _UUIDTextField.text = [NSString stringWithString:tableVC.selectedUUID];
        }
        TrackBeacon *beaconTracker = [segue destinationViewController];
        beaconTracker.selectedUUID = _UUIDTextField.text;
    }
    [self.centralManager stopScan];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"Core bluetooth powered on");
    }
    else {
        return;
    }
    if(self.centralManager){
        NSLog(@"central manager created");
    }
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}
// peripherals are loaded from here
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"Found peripherial with UUID: %@ and name: %@",[NSString stringWithFormat:@"%@", peripheral.identifier.UUIDString], peripheral.name);
    if([setOfUniquePeriperals containsObject:peripheral] == NO){
        [setOfUniquePeriperals addObject:peripheral];
        newString = [[UUIDStore sharedStore]createNewUUIDstring];
        newString.text = [NSString stringWithFormat:@"%@", peripheral.identifier.UUIDString];
        [self reloadTable];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
