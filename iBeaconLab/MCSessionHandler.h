//
//  MCSessionHandler.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 2/20/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCSessionHandler : MCSession

@property (nonatomic,strong) MCSessionHandler *MCSession;
@property (nonatomic,strong) MCNearbyServiceAdvertiser *nearbyServiceAdvertiser;
@property (nonatomic,strong) MCAdvertiserAssistant *advertiserAssistant;
@end
