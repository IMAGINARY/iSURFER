//
//  VideoViewController.h
//  IFIApplicationDemo
//
//  Created by Damain Modernell on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BaseViewController.h"

@interface VideoViewController : BaseViewController {
	
	MPMoviePlayerViewController*	movie;
	MPMoviePlayerController*		player;
	/**
	 *	View that displays the video. Should be set in the Interface builder for
	 * adjusting size and other atributes if necesary
	 */
	IBOutlet UIView*				movieView;

}
@property(nonatomic, retain)IBOutlet UIView*				movieView;
@property(nonatomic, retain)MPMoviePlayerViewController*	movie;
@property(nonatomic, retain)MPMoviePlayerController*		player;

/**
 * Loads a video stored in the iphone 
 *
 * The video gets initialized with default movie playback controls
 * @param videoName
 * @param  videotype
 *
 * 
*/
-(void)loadVideoWithName:(NSString*)name ofType:(NSString*)type;
/**
 *Loads a video from a URL in the web
 * The video gets initialized with default movie playback controls
 *
 * @param URL of the video Ex: @"http://videos/myVideo.mov"
 *
 * 
 */
-(void)loadMovieFromWebURL:(NSString*)urlstr;
/**
 * Starts playing a video
 */
-(void)playVideo;
/**
 * Stops playing a video
 */
-(void)stopVideo;
/**
 * Pauses playing a video
 */
-(void)pauseVideo;
/**
 * Sets the default movie player controls for movie playback
 */
-(void)setDefaultPlayerControls;
/**
 * removes movie default controls in the movie view
 */
-(void)removeMoviePlayerControls;
/**
 * sets a video in full screen mode
 * @param YES for fullscreen mode, NO for normal view
 */
-(void)setFullScreen:(bool)yesorno;

- (void) movieFinishedCallback:(NSNotification*) aNotification;


-(void) moviePreloadDidFinish:(NSNotification*) aNotification;

- (void) movieFinishedCallback:(NSNotification*) aNotification;

@end
