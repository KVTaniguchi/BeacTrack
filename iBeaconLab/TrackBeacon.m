//
//  TrackBeacon.m
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/8/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

/*
    GOAL: POLISH THIS APP
 
    Next - do what the API is meant to do - trigger events in the app based on what
    add a back panel for the beacon data to sit on
 
    Indicate when a peripheral isn't a beacon with a big alert flash and movement back to other screen with a countdown or user swipe arrow
 
    put the beacon data on a layer - will that layer only appear inside its super layer?
 
    indicate when the peripherial being tested is NOT a beacon - big arrow to swipe back, reload in a few seconds
    
    display  flashing text showing close near or far
*/

#import "TrackBeacon.h"

@interface TrackBeacon ()
{
    CALayer *beaconInfoLayer;
    
    CALayer *arrowLayer;
    
    CATextLayer *beaconTextLayer;
    CAShapeLayer *immediateLayer;   // change to far setting
    CAShapeLayer *nearLayer;
    CAShapeLayer *farLayer;         // change to immediate setting
    CAShapeLayer *unknownLayer;
    CGRect fullRect;
    CGRect layerRect;
    CGRect nearRect;
    CGRect immediateRect;
    UIColor *blackColor;
    CGColorRef cgBlack;
    UIColor *immediateColor;
    CGColorRef cgImmediate;
    UIColor *nearColor;
    CGColorRef cgNear;
    UIColor *farColor;
    CGColorRef cgFar;
}
@end

@implementation TrackBeacon

@synthesize beaconRegion, beaconFoundLabel, proxUUIDLabel, transmitMinorLabel, transmitDistanceLabel, transmitMajorLabel, transmitRSSILabel, locationManager, selectedUUID, noBeaconFoundLabel;

-(id)init{
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"selectedUUID is %@", selectedUUID);
    [super viewDidLoad];
    
    [self.beaconFoundLabel setHidden:YES];
    [self.transmitDistanceLabel setHidden:YES];
    [self.transmitRSSILabel setHidden:YES];
    [self.proxUUIDLabel setHidden:YES];
    [self.transmitMajorLabel setHidden:YES];
    [self.transmitMinorLabel setHidden:YES];
    
    self.beaconFoundLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitMinorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitMajorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitRSSILabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.proxUUIDLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    self.transmitDistanceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    if(!self.selectedUUID){
        self.selectedUUID = @"0C369138-C602-4B9A-A80C-E15FEA4DE3A2";
    }
    
    [[self.navigationController navigationBar]setBarStyle:UIBarStyleBlackTranslucent];
    
    self.noBeaconFoundLabel.text = @"";
    
    [self initRegion];
    [self addLayer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

-(void)preferredContentSizeChanged:(NSNotification*)notification{
    self.beaconFoundLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitMinorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitMajorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.transmitRSSILabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.proxUUIDLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    self.transmitDistanceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}


-(void)initRegion{
    NSUUID *u = [[NSUUID alloc]initWithUUIDString:selectedUUID];
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:u identifier:@"asdfasdf"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    CLBeacon *beacon = [[CLBeacon alloc]init];
    beacon = [beacons lastObject];
    
    if(beacon != NULL){
        [self.beaconFoundLabel setHidden:NO];
        [self.transmitDistanceLabel setHidden:NO];
        [self.transmitRSSILabel setHidden:NO];
        [self.proxUUIDLabel setHidden:NO];
        [self.transmitMajorLabel setHidden:NO];
        [self.transmitMinorLabel setHidden:NO];
        [self.noBeaconFoundLabel setHidden:YES];

    if ([beacons count] == 1) {
        self.beaconFoundLabel.text = [NSString stringWithFormat:@"%lu beacon", (unsigned long)[beacons count]];
    }
    else if ([beacons count] > 1){
        self.beaconFoundLabel.text = [NSString stringWithFormat:@"%lu beacons", (unsigned long)[beacons count]];
    }
    NSString *idString = beacon.proximityUUID.UUIDString;
    NSString *beaconUUID = [idString substringFromIndex:([idString length]-4)];
    self.proxUUIDLabel.text = beaconUUID;
    self.transmitMajorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    self.transmitMinorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    if(beacon.proximity == CLProximityUnknown){
        self.transmitDistanceLabel.text = @"unknown";
    } else if (beacon.proximity == CLProximityImmediate){
        self.transmitDistanceLabel.text = @"immediate";
    } else if (beacon.proximity == CLProximityNear){
        self.transmitDistanceLabel.text = @"near";
    } else if (beacon.proximity == CLProximityFar){
        self.transmitDistanceLabel.text = @"far";
    }
    self.transmitRSSILabel.text = [NSString stringWithFormat:@"%li", (long)beacon.rssi];
    }
    else if (beacon == NULL) {
        [self.proxUUIDLabel setHidden:YES];
        [self.transmitDistanceLabel setHidden:YES];
        [self.transmitMajorLabel setHidden:YES];
        [self.transmitMinorLabel setHidden:YES];
        [self.transmitRSSILabel setHidden:YES];
        [self.beaconFoundLabel setHidden:YES];
        [self.noBeaconFoundLabel setText:@"Not a Beacon, slide back"];
    }
    [self updateDrawing:beacon];
    
    [self.locationManager stopMonitoringForRegion:region];
}

-(void)addLayer{
    blackColor = [UIColor blackColor];
    cgBlack = [blackColor CGColor];

    immediateColor = [UIColor colorWithRed:142/255.0f green:229/255.0f blue:185/255.0f alpha:1.0f];
    cgImmediate = [immediateColor CGColor];
    nearColor = [UIColor colorWithRed:142/255.0f green:136/255.0f blue:247/255.0f alpha:1.0f];
    cgNear = [nearColor CGColor];
    farColor = [UIColor colorWithRed:142/255.0f green:137/255.0f blue:142/255.0f alpha:1.0f];
    cgFar = [farColor CGColor];
    
    CGRect frame = [self.view frame];
    fullRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    layerRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 1.9);
    CGRect beaconInfoRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 3);
    CGPoint bottomLeft = CGPointMake(self.view.center.x, CGRectGetMaxY(frame) - (layerRect.size.height / 2));
    
    
    beaconInfoLayer = [CALayer layer];
    beaconInfoLayer.backgroundColor = [[UIColor lightGrayColor]CGColor];
    beaconInfoLayer.frame = CGRectInset(beaconInfoRect, 30, 30);
    [beaconInfoLayer setPosition:CGPointMake(self.view.center.x, CGRectGetMinY(frame) + (layerRect.size.height / 2))];
    [beaconInfoLayer setOpacity:0.1];
    [self.view.layer addSublayer:beaconInfoLayer];
    
    
    UIBezierPath *farPath = [UIBezierPath bezierPathWithOvalInRect:layerRect];
    farLayer = [CAShapeLayer layer];
    farLayer.path = farPath.CGPath;
    [farLayer setFillColor:cgBlack];
    [farLayer setPosition:bottomLeft];
    [farLayer setMasksToBounds:NO];
    [farLayer setBounds:layerRect];
    [farLayer setOpacity:1.0];
    
    nearRect = CGRectMake(self.view.center.x/2.0, layerRect.size.height/4.0, farLayer.frame.size.width/2, farLayer.frame.size.height/2.0);
    UIBezierPath *nearPath = [UIBezierPath bezierPathWithOvalInRect:nearRect];
    nearLayer = [CAShapeLayer layer];
    nearLayer.path = nearPath.CGPath;
    [nearLayer setFillColor:cgBlack];
    
    immediateRect = CGRectMake(self.view.center.x/1.339, nearRect.size.height/1.34, farLayer.frame.size.width/4, farLayer.frame.size.height/4.0);
    UIBezierPath *immediatePath = [UIBezierPath bezierPathWithOvalInRect:immediateRect];
    immediateLayer = [CAShapeLayer layer];
    immediateLayer.path = immediatePath.CGPath;
    [immediateLayer setFillColor:cgBlack];
    
    [farLayer addSublayer:nearLayer];
    [nearLayer addSublayer:immediateLayer];
    [[self.view layer]addSublayer:farLayer];
}

-(void)updateDrawing:(CLBeacon*)beacon{
    // add glow effect
    if (beacon.proximity == CLProximityFar) {
        [self glowEffect:immediateLayer withRect:immediateRect ];
        [immediateLayer setFillColor:[[UIColor grayColor]CGColor]];
        [nearLayer setFillColor:cgBlack];
        [farLayer setFillColor:cgBlack];
        [self removeAnimations:nearLayer secondLayer:farLayer];
    } else
    if (beacon.proximity == CLProximityNear) {
        [self glowEffect:nearLayer withRect:nearRect];
        [nearLayer setFillColor:cgNear];
        [immediateLayer setFillColor:cgNear];
        [farLayer setFillColor:cgBlack];
        [self removeAnimations:immediateLayer secondLayer:farLayer];
    } else
    if (beacon.proximity == CLProximityImmediate) {
        [self glowEffect:farLayer withRect:layerRect];
        [farLayer setFillColor:cgFar];
        [nearLayer setFillColor:cgFar];
        [immediateLayer setFillColor:cgFar];
        [self removeAnimations:nearLayer secondLayer:immediateLayer];
    } else
    if (beacon.proximity == CLProximityUnknown) {
        [nearLayer setFillColor:cgBlack];
        [immediateLayer setFillColor:cgBlack];
        [farLayer setFillColor:cgBlack];
        [immediateLayer removeAllAnimations];
        [nearLayer removeAllAnimations];
        [farLayer removeAllAnimations];
    }
    
}

-(void)glowEffect:(CALayer*)layer withRect:(CGRect)rect{
    CABasicAnimation *glowEffect;
    glowEffect = [CABasicAnimation animationWithKeyPath:@"opacity"];
    glowEffect.duration = 1.0;
    glowEffect.repeatCount = HUGE_VALF;
    glowEffect.autoreverses = NO;
    glowEffect.fromValue = [NSNumber numberWithFloat:0.6];
    glowEffect.toValue = [NSNumber numberWithFloat:0.5];
    [layer addAnimation:glowEffect forKey:@"animateOpacity"];
    [self.view setNeedsDisplay];
}

-(void)removeAnimations:(CALayer*)layer1 secondLayer:(CALayer*)layer2{
    [layer1 removeAllAnimations];
    [layer2 removeAllAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
