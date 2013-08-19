//
//  creditsViewController.m
//  iSurfer
//
//  Created by Cristian Prieto on 15/06/13.
//
//

#import "CreditsViewController.h"

@implementation CreditsViewController

@synthesize creditsLabel, creditsTable, scrollView;

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
    [self createWebViewWithHTML];
    
    [creditsTable sizeToFit];
    [scrollView sizeToFit];

//    CGSize newSize;
    // assume self is the content view
//    CGRect newFrame = (CGRect){CGPointZero,newSize}; // Assuming you want to start at the top-left corner of the scroll view. Change CGPointZero as appropriate
//    [scrollView setContentSize:newSize]; // Change scroll view's content size
//    [self setFrame:newFrame];
    NSLog(@"%f", scrollView.frame.size.width);
    
    float sizeOfContent = 0;
    int i;
    for (i = 0; i < [scrollView.subviews count]; i++) {
        UIView *view =[scrollView.subviews objectAtIndex:i];
        sizeOfContent += view.frame.size.height;
    }
    
    CGRect newFrame = (CGRect){CGPointZero,sizeOfContent};
    [scrollView setFrame: newFrame];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, sizeOfContent);
    NSLog(@"%f", scrollView.frame.size.height);
    
//    float sizeOfContent = 0;
//    int i;
//    for (i = 0; i < [scrollView.subviews count]; i++) {
//        UIView *view =[scrollView.subviews objectAtIndex:i];
//        sizeOfContent += view.frame.size.height;
//    }
//    
//    // Set content size for scroll view
//    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, sizeOfContent);
}

//------------------------------------------------------------------------------

- (void) createWebViewWithHTML{

    creditsTable.scrollView.scrollEnabled = NO;
    creditsTable.scrollView.bounces = NO;
    
    //create the string
        NSMutableString *html = [NSMutableString stringWithString: @"<html><head><meta name=\"viewport\" content=\"user-scalable=no, width=device-width, initial-scale=1.0, maximum-scale=1.0\"/><meta name=\"apple-mobile-web-app-capable\" content=\"yes\"/><title></title></head><body>"];
    
    //continue building the string
    [html appendString: @"<center><table border=\"1\" style=\"width:100%%;\">"];
    [html appendString:     @"<tr><th style=\"width:30px;\">Superficie</th><th style=\"width:200px;\">Fuente</th></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Citrus</td><td style=\"width:200px;\">Wikipedia</td></tr>"];
    [html appendString:     @"<tr><td style=\"width:30px;\">Esfera 3D</td><td style=\"width:200px;\">The Grainger Town Sculptural Map, Neville Street. A 3D representation of Newcastle's Grainger Town by Tod Hanson & Simon Watkinson 2003</td></tr>"];
//    [html appendString:     @"<tr><td>Unir superficies</td><td>NASA</td></tr>"];
//    [html appendString:     @"<tr><td>Mover superficies</td><td>Wikipedia</td></tr>"];
//    [html appendString:     @"<tr><td>Combinar superficies</td><td>Charly Morlock</td></tr>"];
//    [html appendString:     @"<tr><td>Transformando superficies</td><td>http://www.drfranklipman.com/disease-transformation/</td></tr>"];
//    [html appendString:     @"<tr><td>Intersección</td><td>Dalroyd Lane Intersection by Roger May (http://www.geograph.org.uk/photo/124875)</td></tr>"];
//    [html appendString:     @"<tr><td>Dullo</td><td>vicci-blogger http://moonstarsandpaper.blogspot.com.ar/2007_09_01_archive.html</td></tr>"];
//    [html appendString:     @"<tr><td>Mover superficies</td><td>vicci-blogger http://moonstarsandpaper.blogspot.com.ar/2007_09_01_archive.html</td></tr>"];
//    [html appendString:     @"<tr><td>Kreisel</td><td>Revisited: Symmetry in the Upper Sûre Lake by Alfonso Salgueiro Lora - http://www.flickr.com/photos/alsal/6291079735/lightbox/</td></tr>"];
//    [html appendString:     @"<tr><td>Vis a vis</td><td>Foto digital by Rous - Arte y fotografía digital - http://www.arteyfotografia.com.ar/17073/fotos/398319/</td></tr>"];
//    [html appendString:     @"<tr><td>Spitz</td><td>Wikipedia</td></tr>"];
//    [html appendString:     @"<tr><td>Nepali</td><td>Buthan http://www.fotopedia.com/items/flickr-64402224 by babasteve Flickr</td></tr>"];
//    [html appendString:     @"<tr><td>Calyx</td><td>Sea Campion (Silene uniflora) by Anne Burgess - http://www.geograph.org.uk/photo/1925554</td></tr>"];
//    [html appendString:     @"<tr><td>Tulle</td><td>NASA</td></tr>"];
    [html appendString:@"</table></center>"];
    
    [html appendString:@"</body></html>"];
    
    //pass the string to the webview
    [self.creditsTable loadHTMLString:html baseURL:nil];
}

//------------------------------------------------------------------------------

@end
