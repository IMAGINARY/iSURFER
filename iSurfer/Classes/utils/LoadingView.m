//
//  self.m
//  Emmys
//
//  Created by Joaquin Patrono on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView

+(LoadingView*)loadingView:(NSString*)cartel
{
    CGRect frame_=CGRectMake(0,0,200,100);
    LoadingView *lv = [[LoadingView alloc] initWithLoadingFrame:frame_ andText:cartel];
    return lv;
}

-(id)initWithLoadingFrame:(CGRect)frame andText:(NSString*)text
{
    CGRect backgroundFrame;
    backgroundFrame = CGRectMake(0, 0, 480, 320);
      
    self = [super initWithFrame:backgroundFrame];
    if(self)
    {
        // Initialization code
        self.backgroundColor=[UIColor blackColor];
        self.alpha = 0.5;
        UIView *redView = [[UIView alloc] initWithFrame:frame];
        [redView.layer setCornerRadius:20.0f];
        [redView.layer setMasksToBounds:YES];
   //     redView.backgroundColor =[UIColor colorWithRed:91/255.0 green:15/255.0 blue:13/255.0 alpha:1.0];
        redView.backgroundColor = [UIColor darkGrayColor];
        redView.alpha=0.85;
      //  redView.center=CGPointMake(480, 300) ;
        redView.center = self.center;
   //     [self addSubview:redView];
        
        UILabel *title_=[[UILabel alloc] initWithFrame:CGRectMake(redView.frame.origin.x,redView.frame.origin.y + 10,frame.size.width,34)];
        title_.text=text;
        title_.backgroundColor=[UIColor clearColor];
        title_.textColor=[UIColor whiteColor];
        [title_ setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
        title_.textAlignment=UITextAlignmentCenter;
        [self addSubview:title_];
        
        UIActivityIndicatorView *ac=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
        ac.center=CGPointMake(self.center.x, title_.frame.origin.y+title_.frame.size.height+ac.frame.size.width/2);
        [self addSubview:ac];
        [ac startAnimating];
        

    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
