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
	NSString* galleryName;
	NSString* galleryDescription;
	NSMutableArray* surfacesArray;
	BOOL editable;
}
@property(nonatomic, assign)	BOOL editable;
@property(nonatomic, retain)	NSMutableArray* surfacesArray;
@property(nonatomic, retain)	NSString* galleryName;
@property(nonatomic, retain)	NSString* galleryDescription;

-(void)addAlgebraicSurface:(AlgebraicSurface*)surface;
-(void)removeSurfaceAtIndex:(int)index;
-(AlgebraicSurface*)getSurfaceAtIndex:(int)index;

@end
