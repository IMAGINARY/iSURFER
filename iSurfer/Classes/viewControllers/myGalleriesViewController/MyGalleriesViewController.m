//
//  MyGalleriesViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyGalleriesViewController.h"
#import "MyGalleryTableViewCell.h"
//--------------------------------------------------------------------------------------------------------
@implementation MyGalleriesViewController
//--------------------------------------------------------------------------------------------------------
@synthesize galleriesTable;
//--------------------------------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"MyGalleriesViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
	[super viewDidLoad];
	self.title = @"Galleries";
}

//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
}
//--------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"MyGalleryTableViewCell";
	
    MyGalleryTableViewCell *cell = (MyGalleryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
	if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle]
									loadNibNamed:@"MyGalleryTableViewCell"
									owner:nil options:nil];
		
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[MyGalleryTableViewCell class]])
			{
				cell = (MyGalleryTableViewCell *)currentObject;
				break;
			}
		}
		[cell.galleryTitleLabel setText:[NSString stringWithFormat:@"label %d", indexPath.row]];
		
	}
	
	return cell;
	
}
//--------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 8;
}
//--------------------------------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
//--------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return GALLERY_ROW_HEIGHT;
}

//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[super dealloc];
	[galleriesTable release];
}

//--------------------------------------------------------------------------------------------------------

@end
