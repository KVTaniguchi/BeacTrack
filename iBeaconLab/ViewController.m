//
//  ViewController.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/8/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//
/*
    
*/
#import "ViewController.h"

@interface ViewController ()
{
    NSUUID *grabbedUUID;
    NSMutableSet *setOfUniquePeriperals;
}
@end

@implementation ViewController

@synthesize centralManager, discoveredPeripheral, UUIDTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    setOfUniquePeriperals = [NSMutableSet setWithObjects:nil];
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    tableVC = [[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil];
    [tableVC.view setFrame:CGRectMake(0, 200, self.view.frame.size.width, 260)];
    tableVC.view.backgroundColor = [UIColor clearColor];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.UUIDTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self resignFirstResponder];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    else {
        return;
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"Found peripheral: %@", peripheral.description);
    if([setOfUniquePeriperals containsObject:peripheral] == NO){
        NSLog(@"Added Unique Peripheral: %@", peripheral.description);
        [setOfUniquePeriperals addObject:peripheral];
        newPeripheral = [[PeripheralStore sharedStore]addNewPeripheral:peripheral];
        [self reloadTable];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
