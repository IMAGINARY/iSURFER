//
//  AppController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController




-(id)initWithNavController:(UINavigationController*)aNavController{
	if (self = [self init]) {
		/*
		[self setNavcontroller:aNavController];
		[self.navcontroller setDelegate:self];
		
		DB*tmpdb = [[DB alloc]init];
		[self setDatabase:tmpdb];
		[tmpdb release];
		
		[self setSettings:[database getSettings]];
		
		MainMenuViewController* tmpmenu = [[MainMenuViewController alloc]initWithAppController:self];
		[self setMainMenu:tmpmenu];
		[tmpmenu release];
		[SHK flushOfflineQueue];
		
		[self performSelector:@selector(showMainMenu) withObject:nil afterDelay:SPLASH_DELAY];
		 */
	}	
	return self;		
}



@end
