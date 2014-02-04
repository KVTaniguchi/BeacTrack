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

-(id)init{
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification
                                              object:self];
    self.tableView.dataSource = self;
    [self.tableView.tableHeaderView setBackgroundColor:[UIColor clearColor]];
    [self.tableView reloadData];
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
    return [[[PeripheralStore sharedStore]allPeripheralsSet]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    NSSet *passingSet = [[PeripheralStore sharedStore]allPeripheralsSet];
    NSArray *passingArray = [NSArray arrayWithArray:[passingSet allObjects]];
    
    CBPeripheral *peripheral = [passingArray objectAtIndex:[indexPath row]];
    
    NSString *peripheralUUIDString = [NSString stringWithFormat:@"%@", peripheral.identifier.UUIDString];
    NSString *shorterString = [peripheralUUIDString substringFromIndex:([peripheralUUIDString length]-4)];
    
    [[cell textLabel]setText:shorterString];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];

    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    [[cell detailTextLabel]setText:peripheral.name];
    cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [cell.detailTextLabel setTextAlignment:NSTextAlignmentCenter];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 10)];
    [label setFont:[UIFont fontWithName:@"ArialMT" size:10]];
    NSString *headerLabelText = @"Peripherals";
    [label setText:headerLabelText];
    [label setTextColor:[UIColor whiteColor]];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
