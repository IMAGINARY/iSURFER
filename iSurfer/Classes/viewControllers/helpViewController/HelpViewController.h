//
//  HelpViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoViewController.h"

@interface HelpViewController : BaseViewController <UITextFieldDelegate, UIGestureRecognizerDelegate> {

    IBOutlet UIButton* credits;
    IBOutlet UIButton* tutorial;
}

@property(nonatomic, retain)	IBOutlet UIButton* credits;
@property(nonatomic, retain)	IBOutlet UIButton* tutorial;

@end
