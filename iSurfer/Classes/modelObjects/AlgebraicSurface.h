//
//  AlgebraicSurface.h
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlgebraicSurface : NSObject {
	UIImage* surfaceImage;
	NSString* surfaceName;
	NSString* surfaceDescription;
	NSString* equation;
    BOOL saved;
}

@property(nonatomic, retain) NSString* equation;
@property(nonatomic, retain) UIImage* surfaceImage;
@property(nonatomic, retain) NSString* surfaceName;
@property(nonatomic, retain) NSString* surfaceDescription;

@property(nonatomic, assign)     BOOL saved;


@end
