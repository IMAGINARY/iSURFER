//
//  AppController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MainMenuViewController;
@class GoiSurferViewController;
@class MyGalleriesViewController;
@class HelpViewController;
//-------------------------------------------------------------------------------------------------------
@interface AppController : NSObject <UINavigationControllerDelegate> {
	UINavigationController* navcontroller;
	
	MainMenuViewController * mainMenuViewController;
	GoiSurferViewController* goiSurferViewController;
	MyGalleriesViewController* myGalleriesViewController;
	HelpViewController* helpViewController;

}
//--------------------------------------------------------------------------------------------------------
@property(nonatomic, retain)	UINavigationController* navcontroller;

@property(nonatomic, retain)	MyGalleriesViewController* myGalleriesViewController;
@property(nonatomic, retain)	MainMenuViewController * mainMenuViewController;
@property(nonatomic, retain)	GoiSurferViewController* goiSurferViewController;
@property(nonatomic, retain)	HelpViewController* helpViewController;



//--------------------------------------------------------------------------------------------------------


-(id)initWithNavController:(UINavigationController*)aNavController;

- (void)pushViewControllerWithName:(NSString*)vcName;

//--------------------------------------------------------------------------------------------------------

@end
