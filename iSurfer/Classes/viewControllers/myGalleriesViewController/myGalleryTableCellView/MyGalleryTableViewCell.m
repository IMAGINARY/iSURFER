//
//  MyGalleryTableViewCell.m
//  iSurfer
//
//  Created by Damian Modernell on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyGalleryTableViewCell.h"


@implementation MyGalleryTableViewCell

@synthesize galleryImage, galleryTitleLabel, galleryDetailLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


-(void)dealloc{
	[super dealloc];
	[galleryImage release];
	[galleryDetailLabel release];
	[galleryTitleLabel release];
}

@end
