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
#import "HelpViewController.h"
#import "SplashScreenViewController.h"
//--------------------------------------------------------------------------------------------------------
@implementation AppController
//--------------------------------------------------------------------------------------------------------
@synthesize mainMenuViewController, navcontroller, goiSurferViewController, myGalleriesViewController, helpViewController, galleriesArray;
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
		
		HelpViewController* tmphelp = [[HelpViewController alloc]initWithAppController:self];
		[self setHelpViewController:tmphelp];
		[tmphelp release];
		
		NSMutableArray* tmparray = [[NSMutableArray alloc]init];
		[self setGalleriesArray:tmparray];
		[tmparray release];
		
		Gallery* gal1 = [[Gallery alloc]init];
		gal1.galleryName = @"galery1";
		gal1.galleryDescription = @"description1";
		
		Gallery* gal2 = [[Gallery alloc]init];
		gal2.galleryName = @"galery2";
		gal2.galleryDescription = @"description2";

		Gallery* gal3 = [[Gallery alloc]init];
		gal3.galleryName = @"galery3";
		gal3.galleryDescription = @"description3";

		Gallery* gal4 = [[Gallery alloc]init];
		gal4.galleryName = @"galery4";
		gal4.galleryDescription = @"description4";
		
		[self.galleriesArray addObject:gal1];
		[self.galleriesArray addObject: gal2];
		[self.galleriesArray addObject:gal3];
		[self.galleriesArray addObject:gal4];

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
	if( viewController == mainMenuViewController || viewController == goiSurferViewController || [viewController isKindOfClass:[SplashScreenViewController class]]  ){
		[navigationController setNavigationBarHidden:YES animated:YES];
	}else {
		[navigationController setNavigationBarHidden:NO animated:YES];
	}	
}
//--------------------------------------------------------------------------------------------------------

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
}


//--------------------------------------------------------------------------------------------------------
-(void)goBack{
	[self.navcontroller popViewControllerAnimated:YES];
}
//--------------------------------------------------------------------------------------------------------

#pragma mark dealloc
-(void)dealloc{
	[navcontroller release];
	[mainMenuViewController release];
	[goiSurferViewController release];
	[myGalleriesViewController release];
	[helpViewController release];
	[galleriesArray release];
	[super dealloc];
}

//--------------------------------------------------------------------------------------------------------

-(void)addGallery:(Gallery*)gallery atIndex:(int) index{
	if( index == 0 ){
		[self.galleriesArray addObject:gallery];
	}else{
		[self.galleriesArray insertObject:gallery atIndex:index];
	}
}
//--------------------------------------------------------------------------------------------------------

-(void)removeGalleryAtRow:(int)row{
	[self.galleriesArray removeObjectAtIndex:row];
}
//--------------------------------------------------------------------------------------------------------

-(NSMutableArray*)getGalleries{
	return self.galleriesArray;
}
//--------------------------------------------------------------------------------------------------------

@end
