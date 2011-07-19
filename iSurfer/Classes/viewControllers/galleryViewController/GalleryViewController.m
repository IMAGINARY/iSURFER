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

#define BUTTON_SPACE 7

@implementation GalleryViewController
//--------------------------------------------------------------------------------------------------------
@synthesize gallery, surfacesScrollView, surfaceImage, surfacesTable;
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
	CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);    
	self.surfacesTable.transform = transform;  
	self.surfacesTable.frame = CGRectMake(30, 220, 400, 90);
//	self.surfacesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;   
	self.surfacesTable.rowHeight = 90;   
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

//--------------------------------------------------------------------------------------------------------

- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */
//--------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
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
	return 80;
}
//--------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
	return YES;
}
//--------------------------------------------------------------------------------------------------------

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"editingStyleForRowAtIndexPath:");
	return UITableViewCellEditingStyleNone;
}
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
	NSUInteger row = [indexPath row];
	[self.appcontroller removeGalleryAtRow:row];
	[self.surfacesTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
//--------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
	cell.transform = transform;
}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self.surfaceImage setImage:[[gallery.surfacesArray objectAtIndex:[indexPath row]]thumbNailImage]];
}
//--------------------------------------------------------------------------------------------------------
-(void)dealloc{
	[gallery release];
	[surfacesScrollView release];
	[surfaceImage release];
	[surfacesTable release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------

@end
