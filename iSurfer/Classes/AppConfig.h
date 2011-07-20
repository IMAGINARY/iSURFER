//
//  AppConfig.h
//  iSurfer
//
//  Created by Damian Modernell on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SPLASH_DELAY 2

#define GO_ISURFER_BUTTON	1
#define MY_GALLERIES_BUTTON 2
#define HELP_BUTTON			3
#define OTHER_BUTTON		4

#define GALLERY_ROW_HEIGHT	60

#define KEYBOARD_VIEW_SHOW_HEIGHT	110
#define KEYBOARD_VIEW_HIDE_HEIGHT	320

#define OPTIONS_VIEWS_WIDTH			148
#define OPTIONS_VIEWS_HEIGHT		260

#define EQUATION_TEXTFIELD_IDLE_HEIGHT	275
#define EQUATION_TEXTFIELD_EDITING_HEIGHT 255

#define	SHOW_GALLERIES_PICKER	104
#define HIDE_GALLERIES_PICKER	320

typedef enum {
	MOVE = 0,
	DELETE,
	ADD,
}edditingOption;

typedef enum {
	MOVE_BUTTON = 10,
	DELETE_BUTTON,
	ADD_BUTTON,
}edittingButtons;

#define	SURFER_VIDEO_URL	@"http://temp.imaginary2008.de//Video-Surfer-DVPAL-16-9.mp4"