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
@synthesize galleryName, galleryDescription,  editable, galID, thumbNail;
//--------------------------------------------------------------------------------------------------------

-(id) init{	
	if (self = [super init]) {
		self.galleryName = @"";
		self.galleryDescription = @"";
		surfacesArray = nil;
		editable = YES;
		galID = -1;
		thumbNail = nil;
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[galleryName release];
	[galleryDescription release];
	[surfacesArray release];
	[thumbNail release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------

-(void)addAlgebraicSurface:(AlgebraicSurface*)surface{
    if( !surfacesArray ){
        surfacesArray = [[NSMutableArray alloc]init ];
    }
	[surfacesArray addObject:surface];
}
//--------------------------------------------------------------------------------------------------------
-(void)removeSurfaceAtIndex:(int)index{
	[surfacesArray removeObjectAtIndex:index];
}
//--------------------------------------------------------------------------------------------------------

-(AlgebraicSurface*)getSurfaceAtIndex:(int)index{
	return [surfacesArray objectAtIndex:index];
}
//--------------------------------------------------------------------------------------------------------

-(void)putSurface:(AlgebraicSurface*)s  atIndex:(NSUInteger)index{
    
    [surfacesArray insertObject:s atIndex:index];

}
//--------------------------------------------------------------------------------------------------------

-(int)getSurfacesCount{
    
    return [surfacesArray count];
}
//--------------------------------------------------------------------------------------------------------

-(BOOL)isEmpty{
	return  surfacesArray == NULL || [surfacesArray count] == 0 ;
}
//--------------------------------------------------------------------------------------------------------

-(void)removeAllSurfaces{
    
    [surfacesArray removeAllObjects];
}
@end
