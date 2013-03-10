//
//  AppController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "ImageDescriptionViewController.h"
#import "MainMenuViewController.h"
#import "GoiSurferViewController.h"
#import "MyGalleriesViewController.h"
#import "HelpViewController.h"
#import "SplashScreenViewController.h"
#import "GalleryViewController.h"
#import "SaveAlgebraicSurfaceViewController.h"
#import "DataBaseController.h"
#import "Language.h"
//TODO Despues sacar este import
#import "AlgebraicSurface.h"
//--------------------------------------------------------------------------------------------------------
@implementation AppController
//--------------------------------------------------------------------------------------------------------
@synthesize mainMenuViewController, navcontroller, goiSurferViewController, myGalleriesViewController, helpViewController, imageDescriptionViewController,  galleriesArray, dataBase;
//--------------------------------------------------------------------------------------------------------

-(id)initWithNavController:(UINavigationController*)aNavController{
	if (self = [self init]) {
        
        [Language initialize];
		
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
        
        ImageDescriptionViewController * tmpimageDesc = [[ImageDescriptionViewController alloc]initWithAppController:self];
        [self setImageDescriptionViewController:tmpimageDesc];
        [tmpimageDesc release];
		
		NSMutableArray* tmparray = [[NSMutableArray alloc]init];
		[self setGalleriesArray:tmparray];
		[tmparray release];
        
		/*
		Gallery* gal1 = [[Gallery alloc]init];
		gal1.galleryName =[Language get:@"gal1Name" alter:nil];
		gal1.galleryDescription = @"description1";
		gal1.editable = NO;
        [gal1 setThumbNail:[UIImage imageNamed:@"lemon.png"]];

        Gallery* gal2 = [[Gallery alloc]init];
		gal2.galleryName = [Language get:@"gal2Name" alter:nil];
		gal2.galleryDescription = @"description2";
		gal2.editable = NO;
		[gal2 setThumbNail:[UIImage imageNamed:@"nepali.png"]];

		AlgebraicSurface* surface = [[AlgebraicSurface alloc]init];
		[surface setSurfaceImage:[UIImage imageNamed:@"lemon.png"]];
		[surface setEquation:@"x^2+z^2 = y^3(1-y)^3"];
		[surface setSurfaceDescription:[Language get:@"surf1Desc" alter:nil]];
		[surface setSurfaceName:[Language get:@"surf1Name" alter:nil]];
		
		AlgebraicSurface* surface2 = [[AlgebraicSurface alloc]init];
		[surface2 setSurfaceImage:[UIImage imageNamed:@"nepali.png"]];
		[surface2 setEquation:@"(xy-z^3-1)^2 =(1-x^2-y^2)^3"];
		[surface2 setSurfaceDescription:[Language get:@"surf2Desc" alter:nil]];
		[surface2 setSurfaceName:[Language get:@"surf2Name" alter:nil]];
	
		[gal1 addAlgebraicSurface:surface];
		[gal2 addAlgebraicSurface:surface2];
	*/
        
        /*[dataBase saveGallery:gal1];
        [dataBase saveGallery:gal2];*/
        
        [galleriesArray addObjectsFromArray:[dataBase getGalleries]];

        for( Gallery* g in galleriesArray ){
            NSLog(@"%@   editable : %d", g.galleryName, g.editable );
        }
    
			
		[self performSelector:@selector(goToMainScreen) withObject:nil afterDelay:SPLASH_DELAY];
				
	}	
	return self;		
}
//--------------------------------------------------------------------------------------------------------
-(void)goToGalleries{
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.navcontroller.view cache:NO];
    
    [self.navcontroller pushViewController:myGalleriesViewController animated:YES];
    [UIView commitAnimations];
    
}



-(void)goToMainScreen{
	[self.navcontroller pushViewController:goiSurferViewController animated:NO];
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
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
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
	[self.galleriesArray insertObject:gallery atIndex:index];
	//	[self.galleriesArray insertObject:gallery atIndex:index];
	
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
       return [ galleriesArray count];
}
//--------------------------------------------------------------------------------------------------------

-(NSMutableArray*)getEditableGalleries{
    NSMutableArray* editableArray = [NSMutableArray arrayWithCapacity:0];
    for( Gallery* g in galleriesArray ){
        if ( g.editable ){
            [editableArray addObject:g];
        }
    }
    return editableArray;
}
//--------------------------------------------------------------------------------------------------------

-(void)addAlgebraicSurface:(AlgebraicSurface*)surface atGallery:(Gallery*)gallery{
	[gallery addAlgebraicSurface:surface];
    [dataBase saveSurface:surface toGallery:gallery];
}
//--------------------------------------------------------------------------------------------------------

@end
