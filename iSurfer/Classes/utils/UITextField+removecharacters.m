//
//  UITextField+removecharacters.m
//  iSurfer
//
//  Created by Damian Modernell on 6/29/13.
//
//

#import "UITextField+removecharacters.h"

@implementation UITextField (removecharacters)

- (void)setSelectedRange:(NSRange)selectedRange
{
    UITextPosition* from = [self positionFromPosition:self.beginningOfDocument offset:selectedRange.location];
    UITextPosition* to = [self positionFromPosition:from offset:selectedRange.length];
    self.selectedTextRange = [self textRangeFromPosition:from toPosition:to];
}

- (NSRange)selectedRange
{
    UITextRange* range = self.selectedTextRange;
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:range.start];
    NSInteger length = [self offsetFromPosition:range.start toPosition:range.end];
    NSAssert(location >= 0, @"Location is valid.");
    NSAssert(length >= 0, @"Length is valid.");
    return NSMakeRange(location, length);
}

- (void)selectTextForInputatRange:(NSRange)range {
    UITextPosition *start = [self positionFromPosition:[self beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [self positionFromPosition:start
                                               offset:range.length];
    [self setSelectedTextRange:[self textRangeFromPosition:start toPosition:end]];
}
@end
