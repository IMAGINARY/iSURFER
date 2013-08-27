//
//  creditsViewController.h
//  iSurfer
//
//  Created by Cristian Prieto on 15/06/13.
//
//

#import "HelpViewController.h"
#import <Foundation/Foundation.h>

@interface CreditsViewController : HelpViewController {

	IBOutlet UILabel* creditsLabel;
    IBOutlet UIButton* imageCreditsButton;
    IBOutlet UILabel* directedByLabel;
    IBOutlet UILabel* developedByLabel;

}

@property(nonatomic, retain)    IBOutlet UIWebView* creditsTable;
@property(nonatomic, retain)    IBOutlet UIButton* imageCreditsButton;
@property(nonatomic, retain)    IBOutlet UILabel* directedByLabel;
@property(nonatomic, retain)    IBOutlet UILabel* developedByLabel;

@end
