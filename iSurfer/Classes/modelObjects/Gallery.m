//
//  Gallery.m
//  iSurfer
//
//  Created by Damian Modernell on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Gallery.h"


@implementation Gallery

@synthesize galleryName, galleryDescription, surfacesArray;

-(id) init{	
	if (self = [super init]) {
		self.galleryName = @"";
		self.galleryDescription = @"";
		surfacesArray = [[NSMutableArray alloc]init];
	}
	return self;
}

-(void)dealloc{
	[galleryName release];
	[galleryDescription release];
	[surfacesArray release];
	[super dealloc];
}

-(void)addAlgebraicSurface:(AlgebraicSurface*)surface{
	[self.surfacesArray addObject:surface];
}

@end
