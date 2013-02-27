//
//  AlgebraicSurface.h
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlgebraicSurface : NSObject {
    int surfaceID;
	UIImage* surfaceImage;
    NSString* realImageName;
	NSString* surfaceName;
    NSString* briefDescription;
	NSString* completeDescription;
	NSString* equation;
    BOOL saved;
}

@property(nonatomic, assign) int surfaceID;
@property(nonatomic, retain) NSString* equation;
@property(nonatomic, retain) UIImage* surfaceImage;
@property(nonatomic, retain) NSString* realImageName;
@property(nonatomic, retain) NSString* surfaceName;
@property(nonatomic, retain) NSString* briefDescription;
@property(nonatomic, retain) NSString* completeDescription;

@property(nonatomic, assign)     BOOL saved;


@end
