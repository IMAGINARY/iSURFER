//
//  Language.h
//  cards
//
//  Created by Damian Modernell on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject {

}

+(void)initialize;
+(void)setLanguage:(NSString *)l;
+(NSString *)get:(NSString *)key alter:(NSString *)alternate;
+(NSString*)getCurrentLang;
+(int) getLanguageIndex;

@end
