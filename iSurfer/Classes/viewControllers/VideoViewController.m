//
//  VideoViewController.m
//  IFIApplicationDemo
//
//  Created by Damain Modernell on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoViewController.h"

//------------------------------------------------------------------------------
@interface VideoViewController (hidden)
	-(void)loadVideo:(NSURL*)url;
@end
//------------------------------------------------------------------------------
@implementation VideoViewController
//------------------------------------------------------------------------------

@synthesize movieView;
@synthesize movie;
@synthesize player;

//------------------------------------------------------------------------------

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
		
	}
	return self;
}
//------------------------------------------------------------------------------

-(void)loadVideoWithName:(NSString*)name ofType:(NSString*)type{
	NSString *urlstring = [[NSBundle mainBundle] pathForResource:name ofType:type];
	NSURL* url = [NSURL fileURLWithPath:urlstring];
	[self loadVideo:url];
}
//------------------------------------------------------------------------------

-(void)loadMovieFromWebURL:(NSString*)urlstr{
	NSURL* url = [NSURL URLWithString:urlstr];
	[self loadVideo:url];
}
//------------------------------------------------------------------------------

-(void)loadVideo:(NSURL*)url{
	MPMoviePlayerViewController *tmpplayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
	[self setMovie:tmpplayerViewController];
	[tmpplayerViewController release];
		
	self.player = [movie moviePlayer];
	
	//[player respondsToSelector:@selector(loadState)];
//	[player prepareToPlay];

//	[player setFullscreen:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
												selector:@selector(movieFinishedCallback:)
												name:MPMoviePlayerPlaybackDidFinishNotification
											   object:player];
	
	// Register to receive a notification when the movie is in memory and ready to play.
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePreloadDidFinish:) 
												 name:MPMoviePlayerContentPreloadDidFinishNotification 
											   object:player];
	 
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayerLoadStateChanged:) 
												 name:MPMoviePlayerLoadStateDidChangeNotification 
											   object:player];
}
//------------------------------------------------------------------------------

-(void)setDefaultPlayerControls{
	[player setControlStyle:MPMovieControlStyleDefault];
}
//------------------------------------------------------------------------------
-(void)removeMoviePlayerControls{
	[player setControlStyle:MPMovieControlStyleNone];
}
//------------------------------------------------------------------------------
-(void)setFullScreen:(bool)yesorno{
	[player setFullscreen:yesorno];
}
//------------------------------------------------------------------------------
-(void)playVideo{
	NSLog(@"playing");
	[[self movieView] addSubview:movie.view];
	[player play];
}
//------------------------------------------------------------------------------
-(void)stopVideo{
	[player stop];
	[self.movie.view removeFromSuperview];
}
//------------------------------------------------------------------------------
-(void)pauseVideo{
	[player pause];
}
//------------------------------------------------------------------------------

-(void)moviePlayerLoadStateChanged:(NSNotification*) aNotification {
	NSLog(@"moviePlayerLoadStateChanged");
		
	if( player != NULL ){
		MPMovieLoadState state = [player loadState];
		
		NSLog(@"stalled %d",  state & MPMovieLoadStateStalled );
		NSLog(@"Unknown %d",  state & MPMovieLoadStateUnknown );
		NSLog(@"playable %d",  state & MPMovieLoadStatePlayable );
		NSLog(@"Playthrough %d",  state & MPMovieLoadStatePlaythroughOK );

		if( ( state & MPMovieLoadStatePlaythroughOK ) || ( state & MPMovieLoadStatePlayable )) {
			NSLog(@"State is Playthrough OK");
			[self.movieView setHidden:NO];
			[self playVideo];
		}
	}
}
//------------------------------------------------------------------------------

-(void) moviePreloadDidFinish:(NSNotification*) aNotification {
	NSLog(@"moviePreloadDidFinish");
}
//------------------------------------------------------------------------------

- (void) movieFinishedCallback:(NSNotification*) aNotification {
	NSLog(@"movieFinishedCallback");
	player = [aNotification object];
    [player stop];
	[self.movie.view removeFromSuperview];
}
//------------------------------------------------------------------------------
- (void)loadView {
	[super loadView];
}
//------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}
//------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}
//------------------------------------------------------------------------------
-(void)viewWillDisappear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:player];
	
	[self stopVideo];
	self.movie = NULL;
}
//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//------------------------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
//------------------------------------------------------------------------------
- (void)dealloc {
	self.player = NULL;
	[movie release];
	[movieView release];
    [super dealloc];
}
//------------------------------------------------------------------------------

@end
