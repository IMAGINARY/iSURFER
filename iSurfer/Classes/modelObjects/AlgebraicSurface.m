//
//  AlgebraicSurface.m
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlgebraicSurface.h"


@implementation AlgebraicSurface

@synthesize thumbNailImage, surfaceName, surfaceDescription;


-(id) init{	
	if (self = [super init]) {
		self.surfaceName = @"";
		self.surfaceDescription = @"";
		
	}
	return self;
}

-(void)dealloc{
	[surfaceName release];
	[surfaceDescription release];
	[thumbNailImage release];
	[super dealloc];
}


@end
