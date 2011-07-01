//
//  MyGalleriesViewController.h
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface MyGalleriesViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>{

	IBOutlet UITableView* galleriesTable;
}


@property(nonatomic, retain)	IBOutlet UITableView* galleriesTable;


@end
