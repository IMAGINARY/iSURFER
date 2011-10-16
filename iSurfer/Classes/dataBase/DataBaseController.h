//
//  DataBaseController.h
//  iSurfer
//
//  Created by Damian Modernell on 10/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#import "AppConfig.h"
#import	"Gallery.h"

@interface DataBaseController : NSObject {

	FMDatabase* db;
	
}
-(BOOL)openDB;
-(void)insertGallery:(Gallery*)gallery;
-(NSMutableArray*)getGalleries;

@end
