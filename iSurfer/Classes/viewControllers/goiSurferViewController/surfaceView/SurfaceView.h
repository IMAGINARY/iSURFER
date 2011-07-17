//
//  SurfaceView.h
//  iSurfer
//
//  Created by Damian Modernell on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface SurfaceView : UIView {
	CALayer *transformed;
	CGPoint previousLocation;
}

@end
