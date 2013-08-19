//
//  GalleryViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface GalleryViewController : BaseViewController<UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	Gallery* gallery;
    AlgebraicSurface* selectedSurface;
	IBOutlet UIScrollView* surfacesScrollView;
	IBOutlet UIImageView* surfaceImage;
    IBOutlet UIButton* descriptionButton;
    IBOutlet UITextView* briefDescription;
	IBOutlet UITextView* surfaceEquation;
    IBOutlet UIButton* detailedDescription;
    IBOutlet UILabel* surfaceName;

	IBOutlet UITableView* surfacesTable;
	
	UIBarButtonItem* toolbar;
	
	edditingOption eddition;


}
@property(nonatomic, retain)	IBOutlet UITextView* surfaceEquation;



@property(nonatomic, retain)	UIBarButtonItem* toolbar;


@property(nonatomic, retain)	Gallery* gallery;
@property(nonatomic, retain)	AlgebraicSurface* selectedSurface;
@property(nonatomic, retain)	IBOutlet UIScrollView* surfacesScrollView;
@property(nonatomic, retain)	IBOutlet UIImageView* surfaceImage;
@property(nonatomic, retain)    IBOutlet UIButton* descriptionButton;
@property(nonatomic, retain)    IBOutlet UIButton* detailedDescription;
@property(nonatomic, retain)    IBOutlet UITextView* briefDescription;
@property(nonatomic, retain)    IBOutlet UILabel* surfaceName;



@property(nonatomic, retain)	IBOutlet UITableView* surfacesTable;



-(id) initWithAppController:(AppController*)anappCtrl andGallery:(Gallery*)aGallery;

@end
