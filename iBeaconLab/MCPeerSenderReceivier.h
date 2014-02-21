//
//  MCPeerSenderReceivier.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 2/10/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCPeerSenderReceivier : MCPeerID

@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) MCPeerID *myMCPeerID;

@end
