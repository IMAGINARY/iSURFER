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
#import "Language.h"
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
        [Language initialize];

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
	
/*		Gallery* gal3 = [[Gallery alloc]init];
		gal3.galleryName = @"galery3";
		gal3.galleryDescription = @"description3";
		gal3.editable = YES;

		Gallery* gal4 = [[Gallery alloc]init];
		gal4.galleryName = @"galery4";
		gal4.galleryDescription = @"description4";
		gal4.editable = YES;

        [galleriesArray addObject:gal1];
        [galleriesArray addObject:gal2];
        
        */
        
        [galleriesArray addObjectsFromArray:[dataBase getGalleries]];

        for( Gallery* g in galleriesArray ){
            NSLog(@"%@   editable : %d", g.galleryName, g.editable );
        }
    
			
        NSLog(@"jejeje %@",  [Language get:@"scorekey" alter:nil]);

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
	[self.galleriesArray addObject:gallery];
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
    int count = 0;
    for(Gallery* g in galleriesArray){
        if( g.editable == YES){
            count++;
        }
    }
    return count;
}
//--------------------------------------------------------------------------------------------------------

-(void)addAlgebraicSurface:(AlgebraicSurface*)surface atGalleryIndex:(int)index{
	Gallery* g = [self.galleriesArray objectAtIndex:index];
	[g addAlgebraicSurface:surface];
    [dataBase saveSurface:surface toGallery:[self.galleriesArray objectAtIndex:index]];
}
//--------------------------------------------------------------------------------------------------------

@end
