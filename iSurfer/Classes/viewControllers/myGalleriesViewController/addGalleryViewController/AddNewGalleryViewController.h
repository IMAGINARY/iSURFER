//
//  AddNewGalleryViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface AddNewGalleryViewController : BaseViewController {
	IBOutlet UIView* textfieldsView;

}

@property(nonatomic, retain)	IBOutlet UIView* textfieldsView;

-(id) initWithAppController:(AppController*)anappCtrl;
-(IBAction)cancelSave;

@end
