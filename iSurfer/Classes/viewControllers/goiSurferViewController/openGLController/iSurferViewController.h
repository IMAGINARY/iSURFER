//
//  iSurferViewController.h
//  iSurfer
//
//  Created by Ignacio Liverotti on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interfaces.hpp"
#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class TrackBall;
@class GoiSurferViewController;
@interface iSurferViewController : UIViewController
{
    GoiSurferViewController* delegate;
    EAGLContext *context;
    GLuint program;
    IApplicationEngine* m_applicationEngine;
    IRenderingEngine* m_renderingEngine;
    BOOL animating;
    BOOL displayLinkSupported;
    NSInteger animationFrameInterval;
    /*
	 Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	 CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	 The NSTimer object is used only as fallback when running on a pre-3.1 device where CADisplayLink isn't available.
	 */
    id displayLink;
    NSTimer *animationTimer;
	NSAutoreleasePool* pool;
    TrackBall *trackBall;
}

@property(nonatomic, retain) TrackBall *trackBall;


@property (readonly, nonatomic) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

@property (readonly, nonatomic )    IApplicationEngine* m_applicationEngine;



- (void)startAnimation;
- (void)stopAnimation;
-(void)setupGLContxt;
-(void)rotateX:(float)x Y:(float)y;
-(void)initRotationX:(float)x Y:(float)y;

-(void)endRotationX:(float)x Y:(float)y;


-(void)drawFrame;
-(void)setZoom:(double)zoomvalue;
-(void)generateSurface:(NSString*)eq;
-(float)zoom;
-(void)setSurfaceColorRed:(float)red Green:(float)green Blue:(float)blue;
-(void)setSurfaceColor2Red:(float)red Green:(float)green Blue:(float)blue;
-(UIImage *) drawableToCGImage ;

@end
