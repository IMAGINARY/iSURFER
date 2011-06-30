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

}
//---------------------------------------------------------------------------------------------

@property(nonatomic, assign)	AppController* appcontroller;
//---------------------------------------------------------------------------------------------


- (void) scrollViewTo:(UIView*)theView movePixels:(int)pixels;

- (UIImage *)captureView:(UIView *)theView;

@end
