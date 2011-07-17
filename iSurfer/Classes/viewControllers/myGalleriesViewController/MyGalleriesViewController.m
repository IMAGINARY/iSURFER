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
@synthesize galleriesTable, toolbar, galleriesArray;
//--------------------------------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl{
	
	if (self = [super initWithNibName:@"MyGalleriesViewController" bundle:[NSBundle mainBundle]]) {
		
		[self setAppcontroller:anappCtrl];
		NSMutableArray* tmparray = [[NSMutableArray alloc]init];
		[self setGalleriesArray:tmparray];
		[tmparray release];
		
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated{
	tableIsEdditing = NO;
	[super viewWillAppear:animated];
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
	[super viewDidLoad];
	self.title = @"Galleries";
	
	UIImage* img = [UIImage imageNamed:@"icon_sort_order"];
	if( img == NULL)
		NSLog(@"iamge null");
	
	[self.galleriesArray addObject:@"gallery1"];
	[self.galleriesArray addObject: @"gallery2"];
	[self.galleriesArray addObject:@"gallery3"];

	//UIButton *moveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_sort_order"] style:UIBarButtonItemStylePlain target:nil action:nil];
	/*
	UIButton *somebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 30, 30)];
	[somebutton setBackgroundImage:img forState:UIControlStateNormal];
	[somebutton addTarget:self action:@selector(sendmail)
		 forControlEvents:UIControlEventTouchUpInside];
	[somebutton setShowsTouchWhenHighlighted:YES];
	*/
//	UIBarButtonItem *moveButton =[[UIBarButtonItem alloc] initWithCustomView:somebutton];
	UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(moveGalleries)];
	moveButton.tag = 1;
	UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteGalleries)];
	deleteButton.tag = 2;
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGallery)];
	moveButton.tag = 3;
	// Create a spacer.
	UIBarButtonItem* spaceBetweenButtons = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	spaceBetweenButtons.width = 20.0f;
	
	UIToolbar* tmptoolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 130.0f, 33.01f)];
	tmptoolbar.barStyle = -1; // clear background

	NSArray* buttons = [NSArray arrayWithObjects:moveButton, spaceBetweenButtons, deleteButton, spaceBetweenButtons, addButton, nil];
	[tmptoolbar setItems:buttons animated:NO];
	UIBarButtonItem * tmptoolbarItems = [[UIBarButtonItem alloc] initWithCustomView:tmptoolbar];

	[self setToolbar:tmptoolbarItems];

	self.navigationItem.rightBarButtonItem = self.toolbar;
	[tmptoolbar release];
	[moveButton release];
	[spaceBetweenButtons release];
	[deleteButton release];
}
//--------------------------------------------------------------------------------------------------------
-(void)moveGalleries{
	eddition = MOVE;
	[self startEditting];
}
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
	[cell.galleryTitleLabel setText:[NSString stringWithFormat:@"label %d", indexPath.row]];
	//	 cell.showsReorderControl = YES;
	
	return cell;
}
//--------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [galleriesArray count];
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"editingStyleForRowAtIndexPath:");

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
	//id object = [[list objectAtIndex:fromRow] retain];
//	[list removeObjectAtIndex:fromRow];
//	[list insertObject:object atIndex:toRow];
//	[object release];
}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	[self.galleriesArray removeObjectAtIndex:row];
	[self.galleriesTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[galleriesTable release];
	[toolbar release];
	[galleriesArray release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------

-(void)stopEditting{
	tableIsEdditing = NO;
	[self.galleriesTable setEditing:NO animated:YES];
	self.navigationItem.rightBarButtonItem = self.toolbar;
}
//--------------------------------------------------------------------------------------------------------

-(void)startEditting{
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(stopEditting)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];

	[self.galleriesTable setEditing:YES animated:YES];

	/*
		UIActionSheet* edditingOptions = [[UIActionSheet alloc]initWithTitle:@"Edit galleries" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Change galleries order", @"Delete galleries", @"Add gallery",nil ];
		[edditingOptions showInView:self.view];
		[edditingOptions release];
	 */
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
