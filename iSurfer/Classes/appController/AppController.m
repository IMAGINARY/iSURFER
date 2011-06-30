//
//  AppController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "MainMenuViewController.h"
#import "GoiSurferViewController.h"
#import "MyGalleriesViewController.h"
//--------------------------------------------------------------------------------------------------------


@implementation AppController

@synthesize mainMenuViewController, navcontroller, goiSurferViewController, myGalleriesViewController, helpViewController;
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
		MyGalleriesViewController* tmpgal = [[MyGalleriesViewController alloc]initWithAppController:self ];
		[self setMyGalleriesViewController:tmpgal];
		[tmpgal release];
		
		MainMenuViewController* tmpmenu = [[MainMenuViewController alloc]initWithAppController:self];
		[self setMainMenuViewController:tmpmenu];
		[tmpmenu release];
		
		GoiSurferViewController* tmpgosurfer = [[GoiSurferViewController alloc]initWithAppController:self];
		[self setGoiSurferViewController:tmpgosurfer];
		[tmpgosurfer release];
		
		[self performSelector:@selector(showMainMenu) withObject:nil afterDelay:SPLASH_DELAY];
				
	}	
	return self;		
}
//--------------------------------------------------------------------------------------------------------

-(void)showMainMenu{
	[self.navcontroller pushViewController:mainMenuViewController animated:NO];
}
//--------------------------------------------------------------------------------------------------------

- (void) pushViewControllerWithName:(NSString*)vcName {
	
	UIViewController *vc = [self valueForKey:[NSString stringWithFormat:@"%@ViewController",vcName]];
	
	if( vc != NULL ){
		[self.navcontroller pushViewController:vc animated:YES];
	}
}
//--------------------------------------------------------------------------------------------------------
#pragma mark NavigationController
//--------------------------------------------------------------------------------------------------------

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	if( viewController == mainMenuViewController || viewController == goiSurferViewController ){
		[navigationController setNavigationBarHidden:YES animated:YES];
	}else {
		[navigationController setNavigationBarHidden:NO animated:YES];
	}	
}
//--------------------------------------------------------------------------------------------------------

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
}


//--------------------------------------------------------------------------------------------------------
#pragma mark dealloc
-(void)dealloc{
	[super dealloc];
	[navcontroller release];
	[mainMenuViewController release];
	[goiSurferViewController release];
	[myGalleriesViewController release];
	[helpViewController release];
}

//--------------------------------------------------------------------------------------------------------



@end
