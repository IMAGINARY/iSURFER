//
//  iSurferAppDelegate.h
//  iSurfer
//
//  Created by Damian Modernell on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppController.h"
@interface iSurferAppDelegate : NSObject <UIApplicationDelegate> {
	UINavigationController* navcontroller;
    UIWindow *window;
	AppController* appController;
}

@property (nonatomic, retain) IBOutlet 	UINavigationController* navcontroller;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet 	AppController* appController;

@end

