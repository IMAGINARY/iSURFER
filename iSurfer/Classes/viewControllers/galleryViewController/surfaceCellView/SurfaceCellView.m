//
//  SurfaceCellView.m
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurfaceCellView.h"


@implementation SurfaceCellView
//--------------------------------------------------------------------------------------------------------
@synthesize surfaceImageView;
//--------------------------------------------------------------------------------------------------------

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:YES];
}
 
- (void)setHighlighted: (BOOL)highlighted animated: (BOOL)animated
{
	[super setHighlighted:highlighted animated:YES];
}
 
//--------------------------------------------------------------------------------------------------------
-(void)dealloc{
	[surfaceImageView release];
	[super dealloc];
}

//--------------------------------------------------------------------------------------------------------
@end
