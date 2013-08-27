//
//  ImageCreditsViewController.h
//  iSurfer
//
//  Created by Cristian Prieto on 26/08/13.
//
//

#import "CreditsViewController.h"
#import <Foundation/Foundation.h>

@interface ImageCreditsViewController : CreditsViewController {

    IBOutlet UIWebView* creditsTable;
    
}

@property(nonatomic, retain)    IBOutlet UIWebView* creditsTable;

@end
