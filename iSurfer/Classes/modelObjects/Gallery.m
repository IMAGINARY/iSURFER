//
//  Gallery.m
//  iSurfer
//
//  Created by Damian Modernell on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Gallery.h"


@implementation Gallery
//--------------------------------------------------------------------------------------------------------
@synthesize galleryName, galleryDescription, surfacesArray, editable;
//--------------------------------------------------------------------------------------------------------

-(id) init{	
	if (self = [super init]) {
		self.galleryName = @"";
		self.galleryDescription = @"";
		surfacesArray = [[NSMutableArray alloc]init];
		editable = YES;
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[galleryName release];
	[galleryDescription release];
	[surfacesArray release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------

-(void)addAlgebraicSurface:(AlgebraicSurface*)surface{
	[self.surfacesArray addObject:surface];
}
//--------------------------------------------------------------------------------------------------------
-(void)removeSurfaceAtIndex:(int)index{
	[self.surfacesArray removeObjectAtIndex:index];
}
//--------------------------------------------------------------------------------------------------------

-(AlgebraicSurface*)getSurfaceAtIndex:(int)index{
	return [self.surfacesArray objectAtIndex:index];
}
//--------------------------------------------------------------------------------------------------------
@end
