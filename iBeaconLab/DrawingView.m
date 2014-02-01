//
//  DrawingView.m
//  ExpandingCircle
//
//  Created by Kevin Taniguchi on 1/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView

@synthesize circleRadius;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)circleRect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint centerOfView;
    centerOfView.x = self.frame.size.width + self.frame.size.width / 2.0;
    centerOfView.y = self.frame.size.height + self.frame.size.height / 2.0;
    CGRect circleViewFrame = CGRectMake(110, 80, 100, 100);
    CGPoint centerOfCircleViewFrame;
    centerOfCircleViewFrame.x = circleViewFrame.origin.x + circleViewFrame.size.width / 2.0;
    centerOfCircleViewFrame.y = circleViewFrame.origin.y + circleViewFrame.size.height / 2.0;
    CGContextSetLineWidth(context, 10);
    CGContextSetRGBStrokeColor(context, 167/255.0f, 202/255.0f, 178/255.0f, 1.0f);
    CGContextSetRGBFillColor(context, 167/255.0f, 202/255.0f, 178/255.0f, 1.0f);
    CGContextAddArc(context, centerOfCircleViewFrame.x, centerOfCircleViewFrame.y, circleRadius, 0, M_PI * 2.0, YES);
    CGContextStrokePath(context);
}

@end
