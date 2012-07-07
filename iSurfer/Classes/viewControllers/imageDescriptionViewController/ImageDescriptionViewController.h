//
//  ImageDescriptionViewController.h
//  iSurfer
//
//  Created by Cristian Prieto on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ImageDescriptionViewController : BaseViewController {
//    UITextView *textView;
    IBOutlet UIImageView * imageView;
    IBOutlet UIScrollView * scrollView;
    IBOutlet UILabel * formula;
    IBOutlet UILabel * description;
}
//@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UILabel * formula;
@property (nonatomic, retain) UILabel * description;
@end