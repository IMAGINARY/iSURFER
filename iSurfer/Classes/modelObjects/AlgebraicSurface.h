//
//  AlgebraicSurface.h
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlgebraicSurface : NSObject {
	UIImage* thumbNailImage;
	NSString* surfaceName;
	NSString* surfaceDescription;
	NSString* equation;
}

@property(nonatomic, retain) NSString* equation;
@property(nonatomic, retain) UIImage* thumbNailImage;
@property(nonatomic, retain) NSString* surfaceName;
@property(nonatomic, retain) NSString* surfaceDescription;


@end
