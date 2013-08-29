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
    [html appendString:     @"<tr><th style=\"width:30px;\">Surface</th><th style=\"width:200px;\">Source</th></tr>"];
    [html appendString:     @"<tr><th style=\"width:30px;\">First Gallery</th><th style=\"width:200px;\"></th></tr>"];

    [html appendString:     @"<tr><td style=\"width:30px;\">Citrus</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Straight line - Equation of two variables x,y</td><td style=\"width:200px;\">OpenStreetMaps</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Joining surfaces</td><td style=\"width:200px;\">NASA</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Sphere 3D</td><td style=\"width:200px;\">The Grainger Town Sculptural Map, Neville Street. A 3D representation of Newcastle's Grainger Town by Tod Hanson & Simon Watkinson 2003</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Moving surfaces</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Combining surfaces</td><td style=\"width:200px;\">Charly Morlock</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Transforming surfaces</td><td style=\"width:200px;\">http://www.drfranklipman.com/disease-transformation/</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Intersecting surfaces</td><td style=\"width:200px;\">Dalroyd Lane Intersection by Roger May (http://www.geograph.org.uk/photo/124875)</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Pacman</td><td style=\"width:200px;\">Wikipedia</td></tr>"];

    [html appendString:     @"<tr><th style=\"width:30px;\">Second Gallery</th><th style=\"width:200px;\"></th></tr>"];

    [html appendString:     @"<tr><td style=\"width:30px;\">Dullo</td><td style=\"width:200px;\">vicci-blogger http://moonstarsandpaper.blogspot.com.ar/2007_09_01_archive.html</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Kreisel</td><td style=\"width:200px;\">Revisited: Symmetry in the Upper Sûre Lake by Alfonso Salgueiro Lora - http://www.flickr.com/photos/alsal/6291079735/lightbox/</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Vis a vis</td><td style=\"width:200px;\">Foto digital by Rous - Arte y fotografía digital - http://www.arteyfotografia.com.ar/17073/fotos/398319/</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Dromedar</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Tulle</td><td style=\"width:200px;\">NASA</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Nepali</td><td style=\"width:200px;\">Buthan http://www.fotopedia.com/items/flickr-64402224 by babasteve Flickr</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Zeppelin</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Calyx</td><td style=\"width:200px;\">Sea Campion (Silene uniflora) by Anne Burgess - http://www.geograph.org.uk/photo/1925554</td></tr>"];

    [html appendString:     @"<tr><th style=\"width:30px;\">Third Gallery</th><th style=\"width:200px;\"></th></tr>"];

    [html appendString:     @"<tr><td style=\"width:30px;\">Hazelnut</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Geisha</td><td style=\"width:200px;\">Gion geisha dance by Joi Ito - Flickr http://www.fotopedia.com/items/flickr-1284204434</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Harlekin</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Taube</td><td style=\"width:200px;\">wikipedia</td></tr>"];

    
    [html appendString:@"</table></center>"];
    
    [html appendString:@"</body></html>"];
    
    //pass the string to the webview
    [self.creditsTable loadHTMLString:html baseURL:nil];
}

//------------------------------------------------------------------------------

@end
