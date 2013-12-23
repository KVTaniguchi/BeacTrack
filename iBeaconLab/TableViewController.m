//
//  TableViewController.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/19/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize selectedUUID;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSSet *passingSet = [[UUIDStore sharedStore]allUUIDsSet];
    NSArray *passingArray = [NSArray arrayWithArray:[passingSet allObjects]];
    UUIDString *uuidstring = [passingArray objectAtIndex:[indexPath row]];
    NSString *string = [NSString stringWithFormat:@"%@", uuidstring.text];
    NSString *shorterString = [string substringFromIndex:([string length]-4)];
    [[cell textLabel]setText:shorterString];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    return cell;
}

#pragma mark - Table view delegate

//// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSSet *uuidStringsSet = [[UUIDStore sharedStore]allUUIDsSet];
    NSArray *uuidStringArray = [NSArray arrayWithArray:[uuidStringsSet allObjects]];
    UUIDString *stringToPush = [uuidStringArray objectAtIndex:[indexPath row]];
    self.selectedUUID = [NSString stringWithFormat:@"%@", stringToPush.text];
    TrackBeacon *tbvc = [[self.navigationController storyboard]instantiateViewControllerWithIdentifier:@"TrackBeaconVC"];
    tbvc.selectedUUID = [NSString stringWithString:self.selectedUUID];
    [self.navigationController pushViewController:tbvc animated:YES];
}

@end
