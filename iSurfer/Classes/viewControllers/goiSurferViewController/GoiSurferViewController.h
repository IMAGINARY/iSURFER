//
//  GoiSurferViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface GoiSurferViewController : BaseViewController <UITextFieldDelegate>{
	
	IBOutlet UITextField* equationTextField;
}

@property(nonatomic, retain)	IBOutlet UITextField* equationTextField;


@end
