//
//  MCViewController.h
//  SImpleChat
//
//  Created by Kevin Taniguchi on 2/22/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@interface MCViewController : UIViewController <MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate>
@property(nonatomic, strong) MCBrowserViewController *browserVC;
@property(nonatomic, strong) MCAdvertiserAssistant *advertister;
@property(nonatomic, strong) MCSession *mySession;
@property(nonatomic, strong) MCPeerID *myPeerID;

@property(nonatomic, strong) UIButton *browseButton;
@property(nonatomic, strong) UITextView *textBox;
@property(nonatomic, strong) UITextField *chatBox;
@end
