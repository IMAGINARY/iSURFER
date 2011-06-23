//
//  BaseViewController.h
//  cards
//
//  Created by Damian Modernell on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseViewController : UIViewController {

}

- (void) scrollViewTo:(UIView*)theView movePixels:(int)pixels;

- (UIImage *)captureView:(UIView *)theView;

@end
