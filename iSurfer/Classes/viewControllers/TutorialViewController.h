//
//  TutorialViewController.h
//  iSurfer
//
//  Created by Cristian Prieto on 15/06/13.
//
//

#import "HelpViewController.h"
#import <Foundation/Foundation.h>

@interface TutorialViewController : HelpViewController{

    IBOutlet UILabel* tutorialLabel;
}

@property(nonatomic, retain)	IBOutlet UILabel* tutorialLabel;

- (IBAction)openTutorialLink:(id)sender;

@end
