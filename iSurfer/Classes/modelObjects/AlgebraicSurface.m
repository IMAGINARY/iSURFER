//
//  AlgebraicSurface.m
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlgebraicSurface.h"


@implementation AlgebraicSurface
//--------------------------------------------------------------------------------------------------------
@synthesize surfaceImage, surfaceName, surfaceDescription, equation, saved;
//--------------------------------------------------------------------------------------------------------

-(id) init{	
	if (self = [super init]) {
		self.surfaceName = @"";
		self.surfaceDescription = @"";
		self.surfaceImage = nil;
        self.saved = NO;
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[surfaceName release];
	[surfaceDescription release];
	[surfaceImage release];
	[equation release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------
@end
