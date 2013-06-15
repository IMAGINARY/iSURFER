//
//  creditsViewController.m
//  iSurfer
//
//  Created by Cristian Prieto on 15/06/13.
//
//

#import "CreditsViewController.h"

@implementation CreditsViewController

//------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"CreditsViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}

//------------------------------------------------------------------------------

@end
