//
//  ImageCreditsViewController.m
//  iSurfer
//
//  Created by Cristian Prieto on 26/08/13.
//
//

#import "ImageCreditsViewController.h"

@implementation ImageCreditsViewController

@synthesize creditsTable;

//------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"ImageCreditsViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}

//------------------------------------------------------------------------------

-(void)viewDidLoad{
	[super viewDidLoad];
    [self createWebViewWithHTML];
}

//------------------------------------------------------------------------------

- (void) createWebViewWithHTML{
    
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><meta name=\"viewport\" content=\"user-scalable=no, width=device-width, initial-scale=1.0, maximum-scale=1.0\"/><meta name=\"apple-mobile-web-app-capable\" content=\"yes\"/><title></title></head><body>"];
    
    //continue building the string
    [html appendString: @"<center><table border=\"1\" style=\"width:100%%;\">"];
    [html appendString:     @"<tr><th style=\"width:30px;\">Superficie</th><th style=\"width:200px;\">Fuente</th></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Citrus</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Esfera 3D</td><td style=\"width:200px;\">The Grainger Town Sculptural Map, Neville Street. A 3D representation of Newcastle's Grainger Town by Tod Hanson & Simon Watkinson 2003</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Citrus</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Esfera 3D</td><td style=\"width:200px;\">The Grainger Town Sculptural Map, Neville Street. A 3D representation of Newcastle's Grainger Town by Tod Hanson & Simon Watkinson 2003</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Citrus</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Esfera 3D</td><td style=\"width:200px;\">The Grainger Town Sculptural Map, Neville Street. A 3D representation of Newcastle's Grainger Town by Tod Hanson & Simon Watkinson 2003</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Esfera 3D</td><td style=\"width:200px;\">The Grainger Town Sculptural Map, Neville Street. A 3D representation of Newcastle's Grainger Town by Tod Hanson & Simon Watkinson 2003</td></tr>"];
    [html appendString:@"</table></center>"];
    
    [html appendString:@"</body></html>"];
    
    //pass the string to the webview
    [self.creditsTable loadHTMLString:html baseURL:nil];
}

//------------------------------------------------------------------------------

@end
