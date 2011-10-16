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
	
}
@property(nonatomic, assign)	BOOL editable;
@property(nonatomic, retain)	NSMutableArray* surfacesArray;
@property(nonatomic, retain)	NSString* galleryName;
@property(nonatomic, retain)	UIImage * thumbNail;
@property(nonatomic, retain)	NSString* galleryDescription;
@property(nonatomic, assign)	int galID;


-(void)addAlgebraicSurface:(AlgebraicSurface*)surface;
-(void)removeSurfaceAtIndex:(int)index;
-(AlgebraicSurface*)getSurfaceAtIndex:(int)index;
-(BOOL)isEmpty;

@end
