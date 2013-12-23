//
//  HorizontalScroller.h
//  iBeaconLab
//
//  Created by Kevin Taniguchi on 12/18/13.
//  Copyright (c) 2013 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollerDelegate;

@interface HorizontalScroller : UIView

@property (weak) id<HorizontalScrollerDelegate> delegate;

-(void)reload;

@end

@protocol HorizontalScrollerDelegate <NSObject>

@required
-(NSInteger)numberOfViewsForHorizontalSideScroller:(HorizontalScroller*)scroller;
-(UIView*)horizontalScroller:(HorizontalScroller*)scroller viewAtIndex:(int)index;
-(void)horizontalScroller:(HorizontalScroller*)scroller clickedViewAtIndex:(int)index;

@optional
-(NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller*)scroller;

@end