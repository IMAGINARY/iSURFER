//
//  MyGalleryTableViewCell.h
//  iSurfer
//
//  Created by Damian Modernell on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyGalleryTableViewCell : UITableViewCell {
	
	IBOutlet UIImageView* galleryImage;
	IBOutlet UILabel* galleryTitleLabel;
	IBOutlet UILabel* galleryDetailLabel;
}

@property(nonatomic, retain)	IBOutlet UIImageView* galleryImage;
@property(nonatomic, retain)	IBOutlet UILabel* galleryTitleLabel;
@property(nonatomic, retain)	IBOutlet UILabel* galleryDetailLabel;



@end
