//
//  LoadingView.h
//  Emmys
//
//  Created by Joaquin Patrono on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView

+(LoadingView*)loadingView:(NSString*)cartel;

-(id)initWithLoadingFrame:(CGRect)frame andText:(NSString*)text;

@end
