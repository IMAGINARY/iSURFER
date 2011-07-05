//
//  BaseViewController.h
//  cards
//
//  Created by Damian Modernell on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppController.h"
//---------------------------------------------------------------------------------------------


@interface BaseViewController : UIViewController {

	AppController* appcontroller;
	UIView* opaqueView;
}
//---------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIView* opaqueView;
@property(nonatomic, assign)	AppController* appcontroller;
//---------------------------------------------------------------------------------------------


- (void) scrollViewTo:(UIView*)theView movePixels:(int)pixels;

- (UIImage *)captureView:(UIView *)theView;

-(void)popDownView:(UIView*)theView;

-(void)popUpView:(UIView*) theView;


@end
