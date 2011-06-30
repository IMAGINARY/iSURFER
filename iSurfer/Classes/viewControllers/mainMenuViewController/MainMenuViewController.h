//
//  MainMenuViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
//--------------------------------------------------------------------------------------------------------

@interface MainMenuViewController : BaseViewController {
	
	IBOutlet UIView* buttonsView;

}
//--------------------------------------------------------------------------------------------------------

@property(nonatomic, retain)	IBOutlet UIView* buttonsView;

//--------------------------------------------------------------------------------------------------------
-(id) initWithAppController:(AppController*)anappCtrl;

-(IBAction)buttonPressed:(id)sender;


@end
