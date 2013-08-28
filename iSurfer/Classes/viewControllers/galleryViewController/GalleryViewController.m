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
#import "ImageDescriptionViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "GoiSurferViewController+Share.h"

#define BUTTON_SPACE 25.0

@implementation GalleryViewController
//--------------------------------------------------------------------------------------------------------
@synthesize gallery, selectedSurface, surfacesScrollView, surfaceImage, surfacesTable, toolbar, surfaceEquation, briefDescription, descriptionButton, detailedDescription, surfaceName;
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
    [super viewDidLoad];
    [self localize];
    surfaceEquation.clipsToBounds = YES;
    surfaceEquation.layer.cornerRadius = 10.0f;
	
    briefDescription.clipsToBounds = YES;
    briefDescription.layer.cornerRadius = 10.0f;
    
	UIToolbar* tmptoolbar = [[UIToolbar alloc] init];
	tmptoolbar.barStyle = -1; // clear background
	NSMutableArray* items = [[NSMutableArray alloc]init];
	
	UIBarButtonItem* spaceBetweenButtons = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	spaceBetweenButtons.width = BUTTON_SPACE;

	if( [gallery editable] ){
		
//		UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(moveSurfaces)];
//		moveButton.tag = 1;
		UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteSurfaces)];
		deleteButton.tag = 2;
			
		[items addObjectsFromArray:[NSArray arrayWithObjects: spaceBetweenButtons, deleteButton, nil]];

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
	
    UIGestureRecognizer * tabGesture = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(tagHandler:)];
    
    [surfaceImage addGestureRecognizer: tabGesture];
    
    [tabGesture release];
	[actionSheetButton release];
	[spaceBetweenButtons release];
	[tmptoolbar release];
	[tmptoolbarItems release];
	[items release];

}

//--------------------------------------------------------------------------------------------------------

-(void)localize{
    [descriptionButton setTitle:NSLocalizedString(@"DESCRIPTION_BUTTON", nil) forState:UIControlStateNormal];
    [detailedDescription setTitle:NSLocalizedString(@"MORE_BUTTON", nil) forState:UIControlStateNormal];
}

//--------------------------------------------------------------------------------------------------------

- (void)tabGesture: (id)sender{
    NSLog(@"tabGesture");
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSLog(@"clickedButtonAtIndex:");
	NSLog(@"buttonIndes: %d", buttonIndex);
	switch (buttonIndex) {
		
		case 0:
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self.appcontroller.goiSurferViewController doGenerateSurface:self.surfaceEquation.text];
			break;
		default:
			break;
	}
}

//--------------------------------------------------------------------------------------------------------
-(void)showActionSheet{
	 UIActionSheet* edditingOptions = [[UIActionSheet alloc]initWithTitle: NSLocalizedString(@"EDIT_SURFACE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"ISURFER_IMAGE", nil), nil ];
	 [edditingOptions showInView:self.view];
	 [edditingOptions release];
}

//--------------------------------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated{
	if( ![gallery isEmpty]){
		AlgebraicSurface* surface = [gallery getSurfaceAtIndex:0];
        self.selectedSurface = surface;
        [self.surfaceName setText:[surface surfaceName]];
		[self.surfaceImage setImage:surface.surfaceImage];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        UITapGestureRecognizer *descriptionTapGestureRecognizer = [[UITapGestureRecognizer alloc]
            initWithTarget:self action:@selector(descriptionTapHandler:)];
        
        //[self.surfaceImage addGestureRecognizer:tapGestureRecognizer];

		[self.surfaceEquation setText:[surface equation]];
        [self.briefDescription setText:surface.briefDescription];
        [descriptionButton addGestureRecognizer:tapGestureRecognizer];
        [detailedDescription addGestureRecognizer:descriptionTapGestureRecognizer];
        NSLog(@"%@", surface.briefDescription);
        NSLog(@"En galleryviewController %@", surface.equation);
		[super viewWillAppear:animated];
	}
}

-(void)descriptionTapHandler: (UITapGestureRecognizer *)recognizer{
    ImageDescriptionViewController* idvc = [[ImageDescriptionViewController alloc]initWithAppController: self.appcontroller andSurface: selectedSurface];
	[self.navigationController pushViewController: idvc animated:true];
	[idvc release];
    //[self.navigationController pushViewController:self.appcontroller.imageDescriptionViewController animated:true];
}

//--------------------------------------------------------------------------------------------------------
-(void)tapHandler: (UITapGestureRecognizer *)recognizer{
/*    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hello World!"
                                                      message:@"This is your first UIAlertview message."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
      [message show];*/
    //ImageDescriptionViewController* imageDescription = [[ImageDescriptionViewController alloc]initWithAppController:self.appcontroller];
   // briefDescription.text = briefDescription.text +
    briefDescription.hidden = !briefDescription.hidden;
    detailedDescription.hidden = briefDescription.hidden;
    if(gallery.editable)
        detailedDescription.hidden = true;
    surfaceEquation.hidden = !briefDescription.hidden;
    if(briefDescription.hidden)
        [descriptionButton setTitle:NSLocalizedString(@"DESCRIPTION_BUTTON", nil) forState:UIControlStateNormal];
    else
        [descriptionButton setTitle:NSLocalizedString(@"FORMULA_BUTTON", nil) forState:UIControlStateNormal];
    NSLog(@"Brief description %@", briefDescription.text);
//    [self.navigationController pushViewController:self.appcontroller.imageDescriptionViewController animated:false];
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
	AlgebraicSurface* surface = [gallery getSurfaceAtIndex:[indexPath row]];
	[cell.surfaceImageView setImage:surface.surfaceImage];
	return cell;
}
//--------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [gallery getSurfacesCount];
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
	AlgebraicSurface* surface = [[gallery getSurfaceAtIndex:fromRow] retain];
	[gallery removeSurfaceAtIndex:fromRow];
	[gallery putSurface:surface atIndex:toRow];
	[surface release];
}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AlgebraicSurface* surface = [gallery getSurfaceAtIndex:[indexPath row]];
    [appcontroller removeSurface: [gallery getSurfaceAtIndex:[indexPath row]] fromGallery: gallery];
	[self.gallery removeSurfaceAtIndex:[indexPath row]];
	[self.surfacesTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
//--------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	AlgebraicSurface* surface = [gallery getSurfaceAtIndex:[indexPath row]];
    self.selectedSurface = surface;
    [self.surfaceName setText:[surface surfaceName]];
	[self.surfaceImage setImage:[surface surfaceImage]];
	[self.surfaceEquation setText:[surface equation]];
    NSLog(@"surfacesNumber %@", surface.briefDescription);
    [self.briefDescription setText:[surface briefDescription]];
	[tableView scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:UITableViewScrollPositionMiddle	animated:YES];
    // TODO borrar esto
    //[appcontroller pushViewControllerWithName:@"imageDescription"];
}
//--------------------------------------------------------------------------------------------------------
-(void)dealloc{
	[gallery release];
    [selectedSurface release];
	[surfacesScrollView release];
	[surfaceImage release];
	[surfacesTable release];
	[toolbar release];
	[surfaceEquation release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------
@end
