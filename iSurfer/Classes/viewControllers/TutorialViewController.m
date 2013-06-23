//
//  TutorialViewController.m
//  iSurfer
//
//  Created by Cristian Prieto on 15/06/13.
//
//
#import "TutorialViewController.h"

@implementation TutorialViewController

@synthesize tutorialLabel;
//------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"TutorialViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}

//------------------------------------------------------------------------------

@end
