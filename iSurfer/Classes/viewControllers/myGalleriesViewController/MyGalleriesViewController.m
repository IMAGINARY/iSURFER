//
//  MyGalleriesViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyGalleriesViewController.h"
#import "MyGalleryTableViewCell.h"
#import "AddNewGalleryViewController.h"
//--------------------------------------------------------------------------------------------------------
@implementation MyGalleriesViewController
//--------------------------------------------------------------------------------------------------------
@synthesize galleriesTable, toolbar;
//--------------------------------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"MyGalleriesViewController" bundle:[NSBundle mainBundle]]) {
		
		[self setAppcontroller:anappCtrl];
			
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated{
	NSLog(@"viewWillAppear");
	[galleriesTable reloadData];
//	tableIsEdditing = NO;
	[super viewWillAppear:animated];
}
//--------------------------------------------------------------------------------------------------------

-(void)stopEditting{
//	tableIsEdditing = NO;
	eddition = NONE;
	[self.galleriesTable setEditing:NO animated:YES];
	self.navigationItem.rightBarButtonItem = self.toolbar;
}
//--------------------------------------------------------------------------------------------------------

-(void)startEditting{
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(stopEditting)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	[self.galleriesTable setEditing:YES animated:YES];
	
}

//--------------------------------------------------------------------------------------------------------
-(void)viewWillDisappear:(BOOL)animated{
	[self stopEditting];
	[super viewWillDisappear:animated];
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
	[super viewDidLoad];
	self.title = @"Galleries";
	[appcontroller getGalleries];
		
//	UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(moveGalleries)];
//	moveButton.tag = 1;
	UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteGalleries)];
	deleteButton.tag = 2;
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGallery)];
	addButton.tag = 3;
	// Create a spacer.
	UIBarButtonItem* spaceBetweenButtons = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	spaceBetweenButtons.width = 25.0f;
	
	UIToolbar* tmptoolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 130.0f, 33.01f)];
	tmptoolbar.barStyle = -1; // clear background

	NSArray* buttons = [NSArray arrayWithObjects: spaceBetweenButtons, deleteButton, spaceBetweenButtons, addButton, nil];
	[tmptoolbar setItems:buttons animated:NO];
	UIBarButtonItem * tmptoolbarItems = [[UIBarButtonItem alloc] initWithCustomView:tmptoolbar];

	[self setToolbar:tmptoolbarItems];

	self.navigationItem.rightBarButtonItem = self.toolbar;
	[tmptoolbar release];
	[spaceBetweenButtons release];
	[deleteButton release];
	[addButton release];
	[tmptoolbarItems release];
}
////--------------------------------------------------------------------------------------------------------
//-(void)moveGalleries{
//	eddition = MOVE;
//	[self startEditting];
//}
//--------------------------------------------------------------------------------------------------------
-(void)deleteGalleries{
	eddition = DELETE;
	[self startEditting];
}
//--------------------------------------------------------------------------------------------------------

-(void)addGallery{
	AddNewGalleryViewController * addGallery = [[AddNewGalleryViewController alloc]initWithAppController:self.appcontroller];
	[self presentModalViewController:addGallery animated:YES];
	[addGallery release];
}
//--------------------------------------------------------------------------------------------------------
/*																																			
- (IBAction)toggleMove{ 
	[self.galleriesTable setEditing:!self.galleriesTable.editing animated:YES];
	if (self.galleriesTable.editing)
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	else {
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
	}
}
*/
//--------------------------------------------------------------------------------------------------------
#pragma mark tableView methods
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}
//--------------------------------------------------------------------------------------------------------

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	if( eddition == DELETE){
		return YES;
	}
	return NO;
}
//--------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"MyGalleryTableViewCell";
	
    MyGalleryTableViewCell *cell = (MyGalleryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
	if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"MyGalleryTableViewCell"	owner:nil options:nil];
		
		for(id currentObject in topLevelObjects){
			if([currentObject isKindOfClass:[MyGalleryTableViewCell class]]){
				cell = (MyGalleryTableViewCell *)currentObject;
				break;
			}
		}
	}
	Gallery* gallery = [[appcontroller getUpdatedGalleries] objectAtIndex:[indexPath row]];
	[cell.galleryTitleLabel setText:gallery.galleryName];
	[cell.galleryDetailLabel setText:gallery.galleryDescription];
	if( !gallery.thumbNail  ){
		[cell.galleryImage setImage:[UIImage imageNamed:@"Imaginary lemon.jpg"]];
	}else {
		[cell.galleryImage setImage:gallery.thumbNail];
	}
	//	 cell.showsReorderControl = YES
	return cell;
}
//--------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [[appcontroller getGalleries] count];
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
	if( eddition == MOVE){
		return YES;
	}
	return NO;
}
//--------------------------------------------------------------------------------------------------------

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
	if( [[appcontroller getGallery:[indexPath row]]editable] ) {
		return YES;
	}
	return NO;
}
//--------------------------------------------------------------------------------------------------------

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (eddition) {
		case MOVE:
			return UITableViewCellEditingStyleNone;
			break;
		case DELETE:
			return UITableViewCellEditingStyleDelete;
			break;
		default:
			break;
	}
	return UITableViewCellEditingStyleNone;
}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
	NSUInteger fromRow = [fromIndexPath row];
	NSUInteger toRow = [toIndexPath row];
	Gallery* gal = [[[appcontroller getGalleries] objectAtIndex:fromRow] retain];
	[appcontroller  removeGalleryAtRow:fromRow];
	[appcontroller   addGallery:gal atIndex:toRow];
	[gal release];
}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
    [appcontroller removeGallery:[[appcontroller getGalleries] objectAtIndex:[indexPath row]]];
	[self.appcontroller removeGalleryAtRow:row];
	[self.galleriesTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [galleriesTable reloadData];
}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if( [[[appcontroller getGalleries] objectAtIndex:indexPath.row] isEmpty] ){
//    [[[appcontroller getGalleries] objectAtIndex:indexPath.row] surfacesNumber];
    if([[[appcontroller getUpdatedGalleries] objectAtIndex:indexPath.row] surfacesNumber] == 0){
        UIAlertView* emptygal =[[UIAlertView alloc]initWithTitle:@"Empty" message:@"The Gallery is Empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [emptygal show];
        [emptygal release];
    }
//    }
    else{
        [appcontroller accesGallery:[indexPath row]];
    }
}

//--------------------------------------------------------------------------------------------------------
-(void)dealloc{
	[galleriesTable release];
	[toolbar release];
	[super dealloc];
}
/*
//--------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{	NSLog(@"buttonIndes: %d", buttonIndex);
	NSLog(@"clickedButtonAtIndex:");
	NSLog(@"buttonIndes: %d", buttonIndex);

	if( buttonIndex == 3 ){
		tableIsEdditing = NO;
	}else {
		eddition = (edditingOption)buttonIndex;
	}

	[self.galleriesTable setEditing:tableIsEdditing animated:YES];
}
//--------------------------------------------------------------------------------------------------------
*/
@end
