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
	IBOutlet UITextField* galleryName;
	IBOutlet UITextField* galleryDescription;
	IBOutlet UINavigationItem* navBar;
	IBOutlet UIBarButtonItem* saveButton;
}

@property(nonatomic, retain)	IBOutlet UINavigationItem* navBar;
@property(nonatomic, retain)	IBOutlet UIBarButtonItem* saveButton;
@property(nonatomic, retain)	IBOutlet UIView* textfieldsView;
@property(nonatomic, retain)	IBOutlet UITextField* galleryName;
@property(nonatomic, retain)	IBOutlet UITextField* galleryDescription;


-(id) initWithAppController:(AppController*)anappCtrl;
-(IBAction)cancelSave;
-(IBAction)addGallery;

@end
