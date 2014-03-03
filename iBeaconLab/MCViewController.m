//
//  MCViewController.m
//  SImpleChat
//
//  Created by Kevin Taniguchi on 2/22/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "MCViewController.h"


@interface MCViewController ()

@end

@implementation MCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
    [self setUpMultiPeer];
}

-(void)setUpUI{
    self.browseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.browseButton setTitle:@"Browse" forState:UIControlStateNormal];
    self.browseButton.frame = CGRectMake(130, 95, 60, 30);
    [self.view addSubview:self.browseButton];
    self.textBox = [[UITextView alloc]initWithFrame:CGRectMake(40, 220, 240, 270)];
    self.textBox.editable = NO;
    self.textBox.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.textBox];
    self.chatBox = [[UITextField alloc]initWithFrame:CGRectMake(40, 130, 240, 70)];
    self.chatBox.delegate = self;
    self.chatBox.backgroundColor = [UIColor lightGrayColor];
    self.chatBox.returnKeyType = UIReturnKeySend;
    [self.view addSubview:self.chatBox];
    [self.browseButton addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
}


-(void)sendText{
    // get text from chat box and clear chat box
    NSString *message = self.chatBox.text;
    self.chatBox.text = @"";
    // convert text to NSData
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    // send data to connected peers
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    // append your own text to text box
    [self receiveMessage:message fromPeer:self.myPeerID];
}

-(void)setUpMultiPeer{
    self.myPeerID = [[MCPeerID alloc]initWithDisplayName:[UIDevice currentDevice].name];
    self.mySession = [[MCSession alloc]initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    self.browserVC = [[MCBrowserViewController alloc]initWithServiceType:@"chat" session:self.mySession];
    self.browserVC.delegate = self;
    self.advertister = [[MCAdvertiserAssistant alloc]initWithServiceType:@"chat" discoveryInfo:nil session:self.mySession];
    [self.advertister start];
}

-(void)receiveMessage:(NSString*)message fromPeer:(MCPeerID*)peer{
    NSString *finalText;
    if (peer == self.myPeerID) {
        finalText = [NSString stringWithFormat:@"\nme: %@\n", message];
    }
    else{
        finalText = [NSString stringWithFormat:@"\n%@: %@\n", peer.displayName ,message];
    }
    self.textBox.text = [self.textBox.text stringByAppendingString:finalText];
}

-(void)showBrowserVC{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

-(void)dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserMCViewController{
    [self dismissBrowserVC];
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    // decode data back into NSString
    NSString *message = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    // append message to text box on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self receiveMessage:message fromPeer:peerID];
    });
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendText];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
