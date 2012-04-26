//
//  Gallery.h
//  iSurfer
//
//  Created by Damian Modernell on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlgebraicSurface.h"

@interface Gallery : NSObject {
	int galID;
	UIImage * thumbNail;
	NSString* galleryName;
	NSString* galleryDescription;
	NSMutableArray* surfacesArray;
	BOOL editable;
    BOOL saved;
	
}
//--------------------------------------------------------------------------------------------------------
@property(nonatomic, assign)	BOOL editable;
@property(nonatomic, retain)	NSString* galleryName;
@property(nonatomic, retain)	UIImage * thumbNail;
@property(nonatomic, retain)	NSString* galleryDescription;
@property(nonatomic, assign)	int galID;
@property(nonatomic, assign)     BOOL saved;

//--------------------------------------------------------------------------------------------------------
-(void)addAlgebraicSurface:(AlgebraicSurface*)surface;
-(void)removeSurfaceAtIndex:(int)index;
-(AlgebraicSurface*)getSurfaceAtIndex:(int)index;
-(BOOL)isEmpty;
-(int)getSurfacesCount;
-(void)putSurface:(AlgebraicSurface*)s  atIndex:(NSUInteger)index;
-(void)removeAllSurfaces;
//--------------------------------------------------------------------------------------------------------

@end
