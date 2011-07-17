//
//  MyGalleriesViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface MyGalleriesViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{

	IBOutlet UITableView* galleriesTable;
	edditingOption eddition;
	BOOL tableIsEdditing;
	UIBarButtonItem* toolbar;
	NSMutableArray* galleriesArray;
}

@property(nonatomic, retain)	NSMutableArray* galleriesArray;



@property(nonatomic, retain)	UIBarButtonItem* toolbar;


@property(nonatomic, retain)	IBOutlet UITableView* galleriesTable;


@end
