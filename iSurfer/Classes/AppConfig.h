//
//  AppConfig.h
//  iSurfer
//
//  Created by Damian Modernell on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SPLASH_DELAY 1

#define GO_ISURFER_BUTTON	1
#define MY_GALLERIES_BUTTON 2
#define HELP_BUTTON			3
#define OTHER_BUTTON		4

#define GALLERY_ROW_HEIGHT	60

#define VIEW_SCROLL         -60

#define KEYBOARD_VIEW_SHOW_HEIGHT	150
#define KEYBOARD_VIEW_HIDE_HEIGHT	320

#define OPTIONS_VIEWS_WIDTH			148
#define OPTIONS_VIEWS_HEIGHT		260

#define EQUATION_TEXTFIELD_IDLE_HEIGHT	276
#define EQUATION_TEXTFIELD_EDITING_HEIGHT 400

#define	SHOW_GALLERIES_PICKER	104
#define HIDE_GALLERIES_PICKER	320

#define ZOOM_VIEW_X_POSITION	10

typedef enum {
	NONE = 0,
	MOVE,
	DELETE,
	ADD,
}edditingOption;

typedef enum {
	MOVE_BUTTON = 10,
	DELETE_BUTTON,
	ADD_BUTTON,
}edittingButtons;

#define	SURFER_VIDEO_URL	@"http://temp.imaginary2008.de//Video-Surfer-DVPAL-16-9.mp4"

#define	DB_FILE_NAME	@"iSurferDB.db"


#define FULL_SCREEN_SURFACE_FRAME   CGRectMake(0, 0, 440, 320)
