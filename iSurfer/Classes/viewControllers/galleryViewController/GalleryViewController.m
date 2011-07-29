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
	
	if( [gallery editable] ){
		
		UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(moveSurfaces)];
		moveButton.tag = 1;
		UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteSurfaces)];
		deleteButton.tag = 2;
		// Create a spacer.
		UIBarButtonItem* spaceBetweenButtons = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		spaceBetweenButtons.width = BUTTON_SPACE;
		
		UIToolbar* tmptoolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(30.0f, 0.0f, 130.0f, 33.01f)];
		tmptoolbar.barStyle = -1; // clear background
		
		NSArray* buttons = [NSArray arrayWithObjects:moveButton, spaceBetweenButtons, deleteButton, nil];
		[tmptoolbar setItems:buttons animated:NO];
		UIBarButtonItem * tmptoolbarItems = [[UIBarButtonItem alloc] initWithCustomView:tmptoolbar];
		
		[self setToolbar:tmptoolbarItems];
		
		self.navigationItem.rightBarButtonItem = self.toolbar;
		[tmptoolbar release];
		[moveButton release];
		[spaceBetweenButtons release];
		[deleteButton release];
		[tmptoolbarItems release];
	}
	
	/*
	CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);    
	self.surfacesTable.transform = transform;  
	self.surfacesTable.frame = CGRectMake(30, 220, 400, 90);
//	self.surfacesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;   
	self.surfacesTable.rowHeight = 90;   
	 */
/*
	surfacesScrollView.showsHorizontalScrollIndicator =TRUE;
	surfacesScrollView.showsVerticalScrollIndicator = FALSE;
	surfacesScrollView.scrollEnabled = YES;
	surfacesScrollView.bounces = TRUE;
	surfacesScrollView.delegate = self;
	float totalButtonWidth = 0.0f;

	for( AlgebraicSurface* surface in gallery.surfacesArray ){
		
		UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 70,60 )];
		
		// Move the buttons position in the x-demension (horizontal).
		[btn setBackgroundImage:surface.thumbNailImage forState:UIControlStateNormal];
		CGRect btnRect = btn.frame;
		btnRect.origin.x = totalButtonWidth;
		[btn setFrame:btnRect];
		
		// Add the button to the scrollview
		[surfacesScrollView addSubview:btn];
		
		// Add the width of the button to the total width.
		totalButtonWidth += btn.frame.size.width + BUTTON_SPACE;
	}
	
	// Update the scrollview content rect, which is the combined width of the buttons
	//CGSize scrollableSize = CGSizeMake(320, myScrollableHeight);

	[surfacesScrollView setContentSize:CGSizeMake(totalButtonWidth, 70)];
 */
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

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// if the offset is less than 3, the content is scrolled to the far left. This would be the time to show/hide
	// an arrow that indicates that you can scroll to the right. The 3 is to give it some "padding".
	if(scrollView.contentOffset.x <= 3)
	{
		NSLog(@"Scroll is as far left as possible");
	}
	// The offset is always calculated from the bottom left corner, which means when the scroll is as far
	// right as possible it will not give an offset that is equal to the entire width of the content. Example:
	// The content has a width of 500, the scroll view has the width of 200. Then the content offset for far right
	// would be 300 (500-200). Then I remove 3 to give it some "padding"
	else if(scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)-3)
	{
		NSLog(@"Scroll is as far right as possible");
	}
	else
	{
		// The scoll is somewhere in between left and right. This is the place to indicate that the 
		// use can scroll both left and right
	}
	
}

-(IBAction)selectSurface:(id)sender{
	UIButton* button = (UIButton*)sender;
	[self.surfaceImage setImage:[[gallery.surfacesArray objectAtIndex:button.tag]thumbNailImage]];
}
*/
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
