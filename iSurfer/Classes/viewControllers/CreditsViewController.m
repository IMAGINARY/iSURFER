//
//  creditsViewController.m
//  iSurfer
//
//  Created by Cristian Prieto on 15/06/13.
//
//

#import "CreditsViewController.h"
#import "ImageCreditsViewController.h"

@implementation CreditsViewController

@synthesize imageCreditsButton, directedByLabel, developedByLabel;

//------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"CreditsViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}

//------------------------------------------------------------------------------

-(void)viewDidLoad{
	[super viewDidLoad];
    
    [self localize];
    
    [imageCreditsButton addTarget:self action:@selector(showImageCredits) forControlEvents:UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------

-(void)localize{
    [directedByLabel setText:NSLocalizedString(@"DEVELOPED_BY", nil)];
    [developedByLabel setText:NSLocalizedString(@"DIRECTED_BY", nil)];
    [imageCreditsButton setTitle: NSLocalizedString(@"CREDITS_IMAGES", nil) forState:UIControlStateNormal];
}

//------------------------------------------------------------------------------

-(void)showImageCredits{
    ImageCreditsViewController* imagecreditsvc = [[ImageCreditsViewController alloc]initWithAppController: self.appcontroller];
    [self.navigationController pushViewController: imagecreditsvc animated:true];
    [imagecreditsvc release];
}

//------------------------------------------------------------------------------

-(void)dealloc{
	[super dealloc];
    [imageCreditsButton release];
}

@end
