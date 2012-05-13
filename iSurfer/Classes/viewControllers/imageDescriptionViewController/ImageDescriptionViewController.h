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
    IBOutlet UIScrollView *scrollView;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@end