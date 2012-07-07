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
@synthesize surfaceID, surfaceImage, surfaceName, briefDescription, completeDescription, equation, saved;
//--------------------------------------------------------------------------------------------------------

-(id) init{	
	if (self = [super init]) {
        //Falta imagen real para la descripcion completa
		self.surfaceName = @"";
		self.briefDescription = @"";
        self.completeDescription = @"";
		self.surfaceImage = nil;
        self.saved = NO;
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[surfaceName release];
	[briefDescription release];
    [completeDescription release];
	[surfaceImage release];
	[equation release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------
@end
