//
//  TableViewController.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/19/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//  TO DO - subclass the cell to show that

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController
{
}
@synthesize selectedUUID;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification
                                              object:self];
}

-(void)preferredContentSizeChanged:(NSNotification*)notif{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[UUIDStore sharedStore]allUUIDsSet]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    NSSet *passingSet = [[UUIDStore sharedStore]allUUIDsSet];
    NSArray *passingArray = [NSArray arrayWithArray:[passingSet allObjects]];
    
    CBPeripheral *peripheral = [passingArray objectAtIndex:[indexPath row]];
    
    NSString *peripheralUUIDString = [NSString stringWithFormat:@"%@", peripheral.identifier.UUIDString];
    NSString *shorterString = [peripheralUUIDString substringFromIndex:([peripheralUUIDString length]-4)];
    
    [[cell textLabel]setText:shorterString];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];


    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    [[cell detailTextLabel]setText:peripheral.name];
    cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [cell.detailTextLabel setTextAlignment:NSTextAlignmentCenter];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSSet *peripheralSet = [[UUIDStore sharedStore]allUUIDsSet];
    NSArray *peripheralArray = [NSArray arrayWithArray:[peripheralSet allObjects]];
    CBPeripheral *peripheralToPush = [peripheralArray objectAtIndex:[indexPath row]];
    self.selectedUUID = [NSString stringWithFormat:@"%@", peripheralToPush.identifier.UUIDString];
    
    TrackBeacon *tbvc = [[self.navigationController storyboard]instantiateViewControllerWithIdentifier:@"TrackBeaconVC"];
    tbvc.selectedUUID = [NSString stringWithString:self.selectedUUID];
    [self.navigationController pushViewController:tbvc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
