//
//  AppController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gallery.h"
@class MainMenuViewController;
@class GoiSurferViewController;
@class MyGalleriesViewController;
@class HelpViewController;
@class CreditsViewController;
@class TutorialViewController;
@class DataBaseController;
@class ImageDescriptionViewController;

@protocol GalleryProtocol

-(void)addGallery:(Gallery*)gallery atIndex:(int) index;
-(void)removeGalleryAtRow:(int)row;

@end


//-------------------------------------------------------------------------------------------------------
@interface AppController : NSObject <UINavigationControllerDelegate, GalleryProtocol> {
	UINavigationController* navcontroller;
	
	MainMenuViewController * mainMenuViewController;
	GoiSurferViewController* goiSurferViewController;
	MyGalleriesViewController* myGalleriesViewController;
	HelpViewController* helpViewController;
    CreditsViewController * creditsViewController;
    TutorialViewController * tutorialViewController;
    ImageDescriptionViewController * imageDescriptionViewController;
	
	DataBaseController* dataBase;
	
	NSMutableArray* galleriesArray;
    
}
//--------------------------------------------------------------------------------------------------------
@property(nonatomic, retain)	NSMutableArray* galleriesArray;
@property(nonatomic, retain)	UINavigationController* navcontroller;
@property(nonatomic, retain)	MyGalleriesViewController* myGalleriesViewController;
@property(nonatomic, retain)	MainMenuViewController * mainMenuViewController;
@property(nonatomic, retain)	GoiSurferViewController* goiSurferViewController;
@property(nonatomic, retain)	HelpViewController* helpViewController;
@property(nonatomic, retain)	CreditsViewController* creditsViewController;
@property(nonatomic, retain)	TutorialViewController* tutorialViewController;
@property(nonatomic, retain)    ImageDescriptionViewController * imageDescriptionViewController;

@property(nonatomic, retain)	DataBaseController* dataBase;


//--------------------------------------------------------------------------------------------------------

-(id)initWithNavController:(UINavigationController*)aNavController;

- (void)pushViewControllerWithName:(NSString*)vcName;

-(void)goBack;

-(NSMutableArray*)getGalleries;

-(NSMutableArray*)getUpdatedGalleries;

-(void)accesGallery:(int)row;

-(Gallery*)getGallery:(int)index;

-(int)getGalleriesCount;

-(NSMutableArray*)getEditableGalleries;

-(void)addAlgebraicSurface:(AlgebraicSurface*)surface atGallery:(Gallery*)gallery;

-(void)removeSurface:(AlgebraicSurface*)surface fromGallery:(Gallery*) gallery;

-(void) removeGallery:(Gallery*)gallery;

-(void)goToGalleries;

-(void)goToHelp;

//--------------------------------------------------------------------------------------------------------
@end
