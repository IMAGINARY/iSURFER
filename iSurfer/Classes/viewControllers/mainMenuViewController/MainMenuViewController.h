//
//  MainMenuViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "AppController.h"
//--------------------------------------------------------------------------------------------------------

@interface MainMenuViewController : BaseViewController {
	AppController* appcontroller;

}
//--------------------------------------------------------------------------------------------------------

@property(nonatomic, retain)	AppController* appcontroller;
//--------------------------------------------------------------------------------------------------------
-(id) initWithAppController:(AppController*)anappCtrl;

@end
