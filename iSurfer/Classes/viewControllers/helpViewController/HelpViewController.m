//
//  HelpViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"
#import "CreditsViewController.h"
#import "TutorialViewController.h"

@implementation HelpViewController

@synthesize credits, tutorial;
//------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"HelpViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}
//------------------------------------------------------------------------------

-(void)viewDidLoad{
    [self localize];
    [credits addTarget:self action:@selector(showCredits) forControlEvents:UIControlEventTouchUpInside];
    [tutorial addTarget:self action:@selector(showTutorial) forControlEvents: UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------

-(void)localize{
    [credits setTitle:NSLocalizedString(@"CREDITS", nil) forState:UIControlStateNormal];
    [tutorial setTitle:NSLocalizedString(@"TUTORIAL", nil) forState:UIControlStateNormal];
}

//------------------------------------------------------------------------------
-(void)showCredits{
    CreditsViewController* creditsvc = [[CreditsViewController alloc]initWithAppController: self.appcontroller];
    [self.navigationController pushViewController: creditsvc animated:true];
    [creditsvc release];
}
//------------------------------------------------------------------------------

-(void)showTutorial{
    TutorialViewController* tutorialvc = [[TutorialViewController alloc]initWithAppController: self.appcontroller];
    [self.navigationController pushViewController: tutorialvc animated:true];
    [tutorialvc release];
}
//------------------------------------------------------------------------------

-(void)dealloc{
	[super dealloc];
    [credits release];
    [tutorial release];
}
@end
