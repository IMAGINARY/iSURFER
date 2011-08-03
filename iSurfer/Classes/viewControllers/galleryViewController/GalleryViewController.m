//
//  GalleryViewController.m
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GalleryViewController.h"
#import "AlgebraicSurface.h"
#import "SurfaceCellView.h"

#define BUTTON_SPACE 25.0

@implementation GalleryViewController
//--------------------------------------------------------------------------------------------------------
@synthesize gallery, surfacesScrollView, surfaceImage, surfacesTable, toolbar, surfaceEquation;
//--------------------------------------------------------------------------------------------------------

-(id) initWithAppController:(AppController*)anappCtrl andGallery:(Gallery*)aGallery{
	
	if (self = [super initWithNibName:@"GalleryViewController" bundle:[NSBundle mainBundle]]) {
		[self setAppcontroller:anappCtrl];
		[self setGallery:aGallery];
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)viewDidLoad{
	
	UIToolbar* tmptoolbar = [[UIToolbar alloc] init];
	tmptoolbar.barStyle = -1; // clear background
	NSMutableArray* items = [[NSMutableArray alloc]init];
	
	UIBarButtonItem* spaceBetweenButtons = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	spaceBetweenButtons.width = BUTTON_SPACE;

	if( [gallery editable] ){
		
		UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(moveSurfaces)];
		moveButton.tag = 1;
		UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteSurfaces)];
		deleteButton.tag = 2;
			
		[items addObjectsFromArray:[NSArray arrayWithObjects:moveButton, spaceBetweenButtons, deleteButton, nil]];
		
		[moveButton release];
		[deleteButton release];
	}
	
	UIBarButtonItem *actionSheetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)];
	[items addObject:spaceBetweenButtons];
	[items addObject:actionSheetButton];
	[tmptoolbar setItems:items];
	[tmptoolbar setFrame:CGRectMake(0.0, 0.0, 28.0 * [items count], 33.0)];
	UIBarButtonItem * tmptoolbarItems = [[UIBarButtonItem alloc] initWithCustomView:tmptoolbar];

	[self setToolbar:tmptoolbarItems];
	self.navigationItem.rightBarButtonItem = self.toolbar;
	self.navigationItem.title = self.gallery.galleryName;

	[actionSheetButton release];
	[spaceBetweenButtons release];
	[tmptoolbar release];
	[tmptoolbarItems release];
	[items release];

}
//--------------------------------------------------------------------------------------------------------

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSLog(@"clickedButtonAtIndex:");
	NSLog(@"buttonIndes: %d", buttonIndex);
	switch (buttonIndex) {
		case 0:
			//Edit description
			break;
		case 1:
			//go to isurfer with this surface
			break;
		default:
			break;
	}
}

//--------------------------------------------------------------------------------------------------------
-(void)showActionSheet{
	 UIActionSheet* edditingOptions = [[UIActionSheet alloc]initWithTitle:@"Edit Surface" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit description", @"iSurf image", nil ];
	 [edditingOptions showInView:self.view];
	 [edditingOptions release];
}

//--------------------------------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated{
	if( ![gallery isEmpty]){
		AlgebraicSurface* surface = [gallery getSurfaceAtIndex:0];
		[self.surfaceImage setImage:[surface thumbNailImage]];
		[self.surfaceEquation setText:[surface equation]];	
		[super viewWillAppear:animated];
	}
}
//--------------------------------------------------------------------------------------------------------
-(void)stopEditting{
	eddition = NONE;
	CGRect thisViewFrame = surfacesTable.frame;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	self.surfacesTable.frame = CGRectMake(thisViewFrame.origin.x, thisViewFrame.origin.y, thisViewFrame.size.width - 30, thisViewFrame.size.height);
	[UIView commitAnimations];
	
	[self.surfacesTable setEditing:NO animated:YES];
	self.navigationItem.rightBarButtonItem = self.toolbar;
}
//--------------------------------------------------------------------------------------------------------

-(void)startEditting{
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(stopEditting)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect thisViewFrame = surfacesTable.frame;
	self.surfacesTable.frame = CGRectMake(thisViewFrame.origin.x, thisViewFrame.origin.y, thisViewFrame.size.width + 30, thisViewFrame.size.height);
	[UIView commitAnimations];
	
	[self.surfacesTable setEditing:YES animated:YES];
}
//--------------------------------------------------------------------------------------------------------

-(void)moveSurfaces{
	eddition = MOVE;
	[self startEditting];
}
//--------------------------------------------------------------------------------------------------------
-(void)deleteSurfaces{
	eddition = DELETE;
	[self startEditting];
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
	static NSString *CellIdentifier = @"SurfaceCellView";
	
    SurfaceCellView *cell = (SurfaceCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
	if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"SurfaceCellView"owner:nil options:nil];
		
		for(id currentObject in topLevelObjects){
			if([currentObject isKindOfClass:[SurfaceCellView class]]){
				cell = (SurfaceCellView *)currentObject;
				break;
			}
		}
	}
	AlgebraicSurface* surface = [gallery.surfacesArray objectAtIndex:[indexPath row]];
	[cell.surfaceImageView setImage:surface.thumbNailImage];	
	return cell;
}
//--------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [gallery.surfacesArray count];
}
//--------------------------------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
//--------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 70;
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
	if( ![ gallery editable] && eddition == DELETE){
		return NO;
	}
	return YES;
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
	return UITableViewCellEditingStyleNone;}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
	NSUInteger fromRow = [fromIndexPath row];
	NSUInteger toRow = [toIndexPath row];
	AlgebraicSurface* surface = [[gallery.surfacesArray objectAtIndex:fromRow] retain];
	[gallery.surfacesArray removeObjectAtIndex:fromRow];
	[gallery.surfacesArray insertObject:surface atIndex:toRow];
	[surface release];
}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.gallery removeSurfaceAtIndex:[indexPath row]];
	[self.surfacesTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	AlgebraicSurface* surface = [gallery getSurfaceAtIndex:[indexPath row]];
	[self.surfaceImage setImage:[surface thumbNailImage]];
	[self.surfaceEquation setText:[surface equation]];
	[tableView scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:UITableViewScrollPositionMiddle	animated:YES];
}
//--------------------------------------------------------------------------------------------------------
-(void)dealloc{
	[gallery release];
	[surfacesScrollView release];
	[surfaceImage release];
	[surfacesTable release];
	[toolbar release];
	[surfaceEquation release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------
@end
