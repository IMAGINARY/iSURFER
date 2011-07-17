//
//  SurfaceView.m
//  iSurfer
//
//  Created by Damian Modernell on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurfaceView.h"


@implementation SurfaceView


- (void)awakeFromNib {
	transformed = [CALayer layer];
	transformed.frame = self.bounds;
	[self.layer addSublayer:transformed];
	
	CALayer *imageLayer = [CALayer layer];
	imageLayer.frame = CGRectMake(10.0f, 4.0f, 300.0f, 226.0f);
	imageLayer.transform = CATransform3DMakeRotation(20.0f * M_PI / 180.0f,  1.0f, 0.0f, 0.0f);
	imageLayer.contents = (id)[[UIImage imageNamed:@"facebook_icon.png"] CGImage];
	[transformed addSublayer:imageLayer];
}
//---------------------------------------------------------------------------------------------


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	transformed.opacity = 1;

	previousLocation = [[touches anyObject] locationInView:self];
}
//---------------------------------------------------------------------------------------------

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	transformed.opacity = 0;
	//Aca hay que generar la superficie algebraica
}
//---------------------------------------------------------------------------------------------

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	CGPoint location = [[touches anyObject] locationInView:self];
	
	// BJL: The following is the code I used in Molecules to do 3-D rotation
	CATransform3D currentTransform = transformed.sublayerTransform;
	CGFloat displacementInX = location.x - previousLocation.x;
	CGFloat displacementInY = previousLocation.y - location.y;
	
	CGFloat totalRotation = sqrt(displacementInX * displacementInX + displacementInY * displacementInY);
	
	CATransform3D rotationalTransform = CATransform3DRotate(currentTransform, totalRotation * M_PI / 180.0, 
															((displacementInX/totalRotation) * currentTransform.m12 + (displacementInY/totalRotation) * currentTransform.m11), 
															((displacementInX/totalRotation) * currentTransform.m22 + (displacementInY/totalRotation) * currentTransform.m21), 
															((displacementInX/totalRotation) * currentTransform.m32 + (displacementInY/totalRotation) * currentTransform.m31));
	previousLocation = location;
	
	transformed.sublayerTransform = rotationalTransform;
	
	
}

-(void)dealloc {
	[super dealloc];
}



@end
