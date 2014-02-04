//
//  TableViewController.h/Users/KVTANIGUCHI/Dropbox/Apps/Commercial/BeacTrack/iBeaconLab/TableViewController.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/19/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeripheralStore.h"

@interface TableViewController : UITableViewController
@property (nonatomic, strong) NSString *selectedUUID;
@end
