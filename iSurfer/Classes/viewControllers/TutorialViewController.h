//
//  TutorialViewController.h
//  iSurfer
//
//  Created by Cristian Prieto on 15/06/13.
//
//

#import "BaseViewController.h"
#import <Foundation/Foundation.h>

@interface TutorialViewController : BaseViewController{

    IBOutlet UILabel* tutorialLabel;
}

@property(nonatomic, retain)	IBOutlet UILabel* tutorialLabel;

@end
