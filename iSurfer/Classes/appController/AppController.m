//
//  AppController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "MainMenuViewController.h"

//--------------------------------------------------------------------------------------------------------


@implementation AppController

@synthesize mainMenuViewController, navcontroller;
//--------------------------------------------------------------------------------------------------------


-(id)initWithNavController:(UINavigationController*)aNavController{
	if (self = [self init]) {
		
		[self setNavcontroller:aNavController];
		[self.navcontroller setDelegate:self];
		/*
		DB*tmpdb = [[DB alloc]init];
		[self setDatabase:tmpdb];
		[tmpdb release];
		
		[self setSettings:[database getSettings]];
		 */

		MainMenuViewController* tmpmenu = [[MainMenuViewController alloc]initWithAppController:self];
		[self setMainMenuViewController:tmpmenu];
		[tmpmenu release];
		
		[self performSelector:@selector(showMainMenu) withObject:nil afterDelay:SPLASH_DELAY];
				
	}	
	return self;		
}
//--------------------------------------------------------------------------------------------------------

-(void)showMainMenu{
	[self.navcontroller pushViewController:mainMenuViewController animated:YES];
}

-(void)dealloc{
	[super dealloc];
	[navcontroller release];
	[mainMenuViewController release];
}


@end
