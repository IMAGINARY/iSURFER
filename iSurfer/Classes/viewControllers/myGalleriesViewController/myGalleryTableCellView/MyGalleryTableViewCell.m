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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:YES];
}


/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
		
}
*/
-(void)dealloc{
	[galleryImage release];
	[galleryDetailLabel release];
	[galleryTitleLabel release];
	[super dealloc];
}

@end
