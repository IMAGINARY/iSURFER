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
#import "CreditsViewController.h"
#import "ImageCreditsViewController.h"
#import "TutorialViewController.h"
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
@synthesize mainMenuViewController, navcontroller, goiSurferViewController, myGalleriesViewController, helpViewController, creditsViewController, imageCreditsViewController, tutorialViewController, imageDescriptionViewController, galleriesArray, dataBase;
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
        
        CreditsViewController* tmpcredits = [[CreditsViewController alloc]initWithAppController:self];
		[self setCreditsViewController:tmpcredits];
		[tmpcredits release];
        
        ImageCreditsViewController* tmpimagecredits = [[ImageCreditsViewController alloc]initWithAppController:self];
		[self setImageCreditsViewController:tmpimagecredits];
		[tmpimagecredits release];
        
        TutorialViewController* tmptutorial = [[TutorialViewController alloc]initWithAppController:self];
		[self setTutorialViewController:tmptutorial];
		[tmptutorial release];
        
        ImageDescriptionViewController * tmpimageDesc = [[ImageDescriptionViewController alloc]initWithAppController:self];
        [self setImageDescriptionViewController:tmpimageDesc];
        [tmpimageDesc release];
		
		NSMutableArray* tmparray = [[NSMutableArray alloc]init];
		[self setGalleriesArray:tmparray];
		[tmparray release];
        
        [galleriesArray addObjectsFromArray:[dataBase getGalleries]];
    
			
		[self performSelector:@selector(goToMainScreen) withObject:nil afterDelay:SPLASH_DELAY];
				
	}	
	return self;		
}
//--------------------------------------------------------------------------------------------------------
-(void)goToGalleries{
    
      
    [self.navcontroller pushViewController:myGalleriesViewController animated:YES];
    
}

-(void)goToHelp{
    [self.navcontroller pushViewController:helpViewController animated:YES];
}

-(void)goToMainScreen{
	[self.navcontroller setViewControllers:[NSArray arrayWithObject:goiSurferViewController]];
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
	if( viewController == mainMenuViewController || viewController == goiSurferViewController  ){
		[navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    else if([viewController isKindOfClass:[SplashScreenViewController class]] ){
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
    [creditsViewController release];
    [imageCreditsViewController release];
    [tutorialViewController release];
    [imageDescriptionViewController release];
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

-(void)removeSurface:(AlgebraicSurface*)surface fromGallery: (Gallery*) gallery {
	[dataBase deleteSurface:surface fromGallery: gallery];
}

//--------------------------------------------------------------------------------------------------------
-(void) removeGallery:(Gallery*)gallery {
    [dataBase deleteGallery:gallery];
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

-(NSMutableArray*)getUpdatedGalleries{
    return [dataBase getGalleries];
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
