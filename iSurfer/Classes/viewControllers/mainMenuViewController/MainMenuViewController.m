//
//  MainMenuViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"

//--------------------------------------------------------------------------------------------------------

@implementation MainMenuViewController
//--------------------------------------------------------------------------------------------------------

@synthesize appcontroller;
//--------------------------------------------------------------------------------------------------------
-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"MainMenuViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}


//--------------------------------------------------------------------------------------------------------


@end
