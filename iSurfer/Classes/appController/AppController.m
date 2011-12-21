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
#import "DataBaseController.h"
//Despues sacar este import
#import "AlgebraicSurface.h"
//--------------------------------------------------------------------------------------------------------
@implementation AppController
//--------------------------------------------------------------------------------------------------------
@synthesize mainMenuViewController, navcontroller, goiSurferViewController, myGalleriesViewController, helpViewController, galleriesArray, dataBase;
//--------------------------------------------------------------------------------------------------------

-(id)initWithNavController:(UINavigationController*)aNavController{
	if (self = [self init]) {
		
		[self setNavcontroller:aNavController];
		[self.navcontroller setDelegate:self];
		
		DataBaseController* tmpdb = [[DataBaseController alloc]init];
		self.dataBase = tmpdb;
		[tmpdb release];
		
		[dataBase openDB];
	
		
		MyGalleriesViewController* tmpgal = [[MyGalleriesViewController alloc]initWithAppController:self ];
		[self setMyGalleriesViewController:tmpgal];
		[tmpgal release];
		
		MainMenuViewController* tmpmenu = [[MainMenuViewController alloc]initWithAppController:self];
		[self setMainMenuViewController:tmpmenu];
		[tmpmenu release];
		
		GoiSurferViewController* tmpgosurfer = [[GoiSurferViewController alloc]initWithAppController:self andAlgebraicSurface:nil];
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
		gal1.editable = NO;
		
		AlgebraicSurface* surface = [[AlgebraicSurface alloc]init];
		[surface setSurfaceImage:[UIImage imageNamed:@"facebook_icon.png"]];
		[surface setEquation:@"x^2 + y^2 + z^2 = 1"];
		[surface setSurfaceDescription:@"surface description"];
		[surface setSurfaceName:@"surface name 1"];
		
		AlgebraicSurface* surface2 = [[AlgebraicSurface alloc]init];
		[surface2 setSurfaceImage:[UIImage imageNamed:@"Logo-twitter.png"]];
		[surface2 setEquation:@"x^2 + y^2 + z^2 = 2"];
		[surface2 setSurfaceDescription:@"surface description 222"];
		[surface2 setSurfaceName:@"surface name 2"];
		/*
		AlgebraicSurface* surface3 = [[AlgebraicSurface alloc]init];
		[surface3 setSurfaceImage:[UIImage imageNamed:@"Imaginary lemon.jpg"]];
		AlgebraicSurface* surface4 = [[AlgebraicSurface alloc]init];
		[surface4 setSurfaceImage:[UIImage imageNamed:@"facebook_icon.png"]];
		AlgebraicSurface* surface5 = [[AlgebraicSurface alloc]init];
		[surface5 setSurfaceImage:[UIImage imageNamed:@"facebook_icon.png"]];
		AlgebraicSurface* surface6 = [[AlgebraicSurface alloc]init];
		[surface6 setSurfaceImage:[UIImage imageNamed:@"facebook_icon.png"]];
				
		[gal1.surfacesArray addObject:surface];
		[gal1.surfacesArray addObject:surface2];
		[gal1.surfacesArray addObject:surface3];
		[gal1.surfacesArray addObject:surface4];
		[gal1.surfacesArray addObject:surface5];
		[gal1.surfacesArray addObject:surface6];
		 */

	
		
		Gallery* gal2 = [[Gallery alloc]init];
		gal2.galleryName = @"galery2";
		gal2.galleryDescription = @"description2";
		gal2.editable = YES;
		[gal2 setThumbNail:[UIImage imageNamed:@"facebook_icon.png"]];

		Gallery* gal3 = [[Gallery alloc]init];
		gal3.galleryName = @"galery3";
		gal3.galleryDescription = @"description3";
		gal3.editable = YES;

		Gallery* gal4 = [[Gallery alloc]init];
		gal4.galleryName = @"galery4";
		gal4.galleryDescription = @"description4";
		gal4.editable = YES;

	
	//	[dataBase saveGallery:gal2];
//		[dataBase saveGallery:gal3];
//		[dataBase saveGallery:gal4];
		self.galleriesArray = [dataBase getGalleries];

	//	[dataBase saveSurface:surface toGallery:[self.galleriesArray objectAtIndex:0]];
	//	[dataBase saveSurface:surface2 toGallery:[self.galleriesArray objectAtIndex:0]];

		[surface release];
		[surface2 release];
		[gal1 release];
		[gal2 release];
		[gal3 release];
		[gal4 release];
		
		
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
	[dataBase release];
	[super dealloc];
}

//--------------------------------------------------------------------------------------------------------

-(void)addGallery:(Gallery*)gallery atIndex:(int) index{
	if( index == 0 ){
		[self.galleriesArray addObject:gallery];
	}else{
		[self.galleriesArray insertObject:gallery atIndex:index];
	}
	[dataBase saveGallery:gallery];
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
	Gallery* g = [self.galleriesArray objectAtIndex:row];
	[dataBase populateGallery:g];
	GalleryViewController* gallery = [[GalleryViewController alloc]initWithAppController:self andGallery:g];
	[self.navcontroller pushViewController:gallery animated:YES];
	[gallery release];
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
    [dataBase saveSurface:surface toGallery:[self.galleriesArray objectAtIndex:index]];
}
//--------------------------------------------------------------------------------------------------------

@end
