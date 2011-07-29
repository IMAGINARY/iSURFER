//
//  GalleryViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface GalleryViewController : BaseViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
	Gallery* gallery;
	IBOutlet UIScrollView* surfacesScrollView;
	IBOutlet UIImageView* surfaceImage;
	IBOutlet UILabel* surfaceEquation;

	IBOutlet UITableView* surfacesTable;
	
	UIBarButtonItem* toolbar;
	
	edditingOption eddition;


}
@property(nonatomic, retain)	IBOutlet UILabel* surfaceEquation;



@property(nonatomic, retain)	UIBarButtonItem* toolbar;


@property(nonatomic, retain)	Gallery* gallery;
@property(nonatomic, retain)	IBOutlet UIScrollView* surfacesScrollView;
@property(nonatomic, retain)	IBOutlet UIImageView* surfaceImage;



@property(nonatomic, retain)	IBOutlet UITableView* surfacesTable;



-(id) initWithAppController:(AppController*)anappCtrl andGallery:(Gallery*)aGallery;

@end
