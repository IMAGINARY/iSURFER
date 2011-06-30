//
//  HelpViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"


@implementation HelpViewController



-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"HelpViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}


-(void)dealloc{
	[super dealloc];
}

@end
