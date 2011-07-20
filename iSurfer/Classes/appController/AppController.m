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
#import "GalleryViewController.h"
#import "SaveAlgebraicSurfaceViewController.h"

//Despues sacar este import
#import "AlgebraicSurface.h"
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
		
		AlgebraicSurface* surface = [[AlgebraicSurface alloc]init];
		[surface setThumbNailImage:[UIImage imageNamed:@"facebook_icon.png"]];
		AlgebraicSurface* surface2 = [[AlgebraicSurface alloc]init];
		[surface2 setThumbNailImage:[UIImage imageNamed:@"Logo-twitter.png"]];
		AlgebraicSurface* surface3 = [[AlgebraicSurface alloc]init];
		[surface3 setThumbNailImage:[UIImage imageNamed:@"Imaginary lemon.jpg"]];
		AlgebraicSurface* surface4 = [[AlgebraicSurface alloc]init];
		[surface4 setThumbNailImage:[UIImage imageNamed:@"facebook_icon.png"]];
		AlgebraicSurface* surface5 = [[AlgebraicSurface alloc]init];
		[surface5 setThumbNailImage:[UIImage imageNamed:@"facebook_icon.png"]];
		AlgebraicSurface* surface6 = [[AlgebraicSurface alloc]init];
		[surface6 setThumbNailImage:[UIImage imageNamed:@"facebook_icon.png"]];
		[gal1.surfacesArray addObject:surface];
		[gal1.surfacesArray addObject:surface2];
		[gal1.surfacesArray addObject:surface3];
		[gal1.surfacesArray addObject:surface4];
		[gal1.surfacesArray addObject:surface5];
		[gal1.surfacesArray addObject:surface6];

	
		
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
/*
-(void)goToSaveImage{
	SaveAlgebraicSurfaceViewController* saveimg = [[SaveAlgebraicSurfaceViewController alloc]initWithAppController:self];
	[self.navcontroller pushViewController:saveimg animated:YES];
	[saveimg release];
}
 */
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

-(void)accesGallery:(int)row{
	GalleryViewController* gallery = [[GalleryViewController alloc]initWithAppController:self andGallery:[self.galleriesArray objectAtIndex:row]];
	[self.navcontroller pushViewController:gallery animated:YES];
}
//--------------------------------------------------------------------------------------------------------
-(Gallery*)getGallery:(int)index{
	return [self.galleriesArray objectAtIndex:index];
}
//--------------------------------------------------------------------------------------------------------
-(int)getGalleriesCount{
	return [self.galleriesArray count];
}
//--------------------------------------------------------------------------------------------------------

-(void)addAlgebraicSurface:(AlgebraicSurface*)surface atGalleryIndex:(int)index{
	Gallery* g = [self.galleriesArray objectAtIndex:index];
	[g addAlgebraicSurface:surface];
}
//--------------------------------------------------------------------------------------------------------

@end
