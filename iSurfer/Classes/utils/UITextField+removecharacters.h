//
//  UITextField+removecharacters.h
//  iSurfer
//
//  Created by Damian Modernell on 6/29/13.
//
//

#import <UIKit/UIKit.h>

@interface UITextField (removecharacters)
- (NSRange)selectedRange;
- (void)selectTextForInputatRange:(NSRange)range;

@end
