//
//  AppController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MainMenuViewController;
//-------------------------------------------------------------------------------------------------------
@interface AppController : NSObject {
	UINavigationController* navcontroller;
	
	MainMenuViewController * mainMenuViewController;
	

}
//--------------------------------------------------------------------------------------------------------
@property(nonatomic, retain)	UINavigationController* navcontroller;

@property(nonatomic, retain)	MainMenuViewController * mainMenuViewController;
//--------------------------------------------------------------------------------------------------------


-(id)initWithNavController:(UINavigationController*)aNavController;

//--------------------------------------------------------------------------------------------------------

@end
