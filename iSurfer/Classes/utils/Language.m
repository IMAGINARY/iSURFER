//
//  Language.m
//  cards
//
//  Created by Damian Modernell on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Language.h"


@implementation Language
//---------------------------------------------------------------------------------------------
static NSBundle *bundle = nil;
static NSString* lang = nil;
//---------------------------------------------------------------------------------------------
+(void)initialize {
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];
	NSString *current = [[languages objectAtIndex:0] retain];
	NSLog(@"lang    %@", current);
	lang = current;
	
	[self setLanguage:current];
}
//---------------------------------------------------------------------------------------------
/*
 example calls:
 [Language setLanguage:@"it"];
 [Language setLanguage:@"de"];
 */
+(void)setLanguage:(NSString *)l {
	NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
	bundle = [[NSBundle bundleWithPath:path] retain];
	lang = l;
}
//---------------------------------------------------------------------------------------------

+(NSString *)get:(NSString *)key alter:(NSString *)alternate {
	return [bundle localizedStringForKey:key value:alternate table:nil];
}
//---------------------------------------------------------------------------------------------

+(NSString*)getCurrentLang{
	return lang;
}
//---------------------------------------------------------------------------------------------
+(int) getLanguageIndex{
    if([lang isEqualToString: @"es"])
        return 1;
    return 0;
}

@end
