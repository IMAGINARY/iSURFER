//
//  UINavigationController+rotate.m
//  iSurfer
//
//  Created by Damian Modernell on 2/11/13.
//
//

#import "UINavigationController+rotate.h"



@implementation UINavigationController (rotate)


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL) shouldAutorotate {
    return YES;
}



@end