/*
 *  ImageDescriptionViewController.h
 *  iSurfer
 *
 *  Created by Cristian Prieto on 25/04/12.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface ScrollViewExampleViewController : UIViewController {
	
	IBOutlet UIScrollView *scrollview;
    IBOutlet UITextField *textField1;
    IBOutlet UITextField *textField2;
	
	BOOL displayKeyboard;
	CGPoint  offset;
	UITextField *Field;
}

@property(nonatomic,retain) IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain) IBOutlet UITextField *textField1;
@property(nonatomic,retain) IBOutlet UITextField *textField2;
