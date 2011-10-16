//
//  DataBaseController.m
//  iSurfer
//
//  Created by Damian Modernell on 10/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataBaseController.h"
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); return 123; } }

//------------------------------------------------------------------------
@implementation DataBaseController
//------------------------------------------------------------------------

-(id) init{
	
	if (self = [super init]) {
			
		NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentsPath objectAtIndex:0];
		NSString *databasePath = [documentsDir stringByAppendingPathComponent:DB_FILE_NAME];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:databasePath error:nil];

		BOOL success = [fileManager fileExistsAtPath:databasePath];
		
		if (!success) {
			
			NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_FILE_NAME];
			NSLog(@"%@", databasePathFromApp);
			[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
		}
		NSLog(@"%@", databasePath);

		[fileManager release];
				
	//	db = [[FMDatabase alloc]initWithPath: [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] pathForResource:@"iSurferDB" ofType:@"db"], DB_FILE_PATH]];
		db = [[FMDatabase alloc]initWithPath: databasePath];

	}
	return self;
}

//------------------------------------------------------------------------
-(BOOL)openDB{
	if( ![db open]){
		FMDBQuickCheck([db hadError]);

	}
	return YES;
}

//------------------------------------------------------------------------

-(void)closeDB{
	[db close];
}
//------------------------------------------------------------------------

-(void)dealloc{
	[db release];
	[super dealloc];
}
//------------------------------------------------------------------------

-(void)saveSurface:(AlgebraicSurface*)surface toGallery:(Gallery*)gal{
	
	NSLog(@"saveSurface");
	[db beginTransaction];
	NSData* imgdata = UIImagePNGRepresentation(surface.surfaceImage);
	
	[db executeUpdate:@"insert into algebraicsurfaces (surfaceName, surfaceDescription, equation, surfaceimage, gallery_id) values (?, ?, ?, ?, ?)",	
	 surface.surfaceName,
	 surface.surfaceDescription,
	 surface.equation,
	 imgdata,
	 [NSNumber numberWithInt:gal.galID]];
	FMDBQuickCheck([db hadError]);
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
	
    [db commit];
	
}

//------------------------------------------------------------------------

-(void)saveGallery:(Gallery*)gallery{
	NSLog(@"saveGallery");
	[db beginTransaction];
	NSData* imgdata = UIImagePNGRepresentation(gallery.thumbNail);

	[db executeUpdate:@"insert into galleries (galleryname, description, editable, thumbnail) values (?, ?, ?, ?)",	
	 gallery.galleryName,
	 gallery.galleryDescription,
	 [NSNumber numberWithInt:gallery.editable], 
	 imgdata];
	FMDBQuickCheck([db hadError]);
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
	
    [db commit];
	
}
//------------------------------------------------------------------------

-(NSMutableArray*)getGalleries{
	NSLog(@"getGalleries");
	
	//FMResultSet *rs2 =	[db executeQuery:@"SELECT * FROM sqlite_master WHERE type='table'"];

	FMResultSet *rs = [db executeQuery:@"select * from galleries"];
	Gallery* g = nil;
	NSMutableArray* array = [[[NSMutableArray alloc]init] autorelease];
	while ([rs next]) {
		g = [[Gallery alloc]init];
	
		g.galID = [rs intForColumn:@"serial"];
		g.galleryName = [rs stringForColumn:@"galleryname"];
		g.galleryDescription =  [rs stringForColumn:@"description"];
		g.editable = [rs intForColumn:@"editable"];
		
		if( ![rs dataForColumn:@"thumbnail"] ){
			g.thumbNail = [UIImage imageNamed:@"Imaginary lemon.jpg"];
		}else {
			UIImage* img = [UIImage imageWithData:[rs dataForColumn:@"thumbnail"]];
			g.thumbNail = img;
		}


		// just print out what we've got in a number of formats.
		NSLog(@"%d %@ %@ %d",
			  [rs intForColumn:@"serial"],
			  [rs stringForColumn:@"galleryname"],
			  [rs stringForColumn:@"description"],
			  [rs intForColumn:@"editable"]);
	
		[array addObject:g];
		[g release];
	}
	
	[rs close];  
	 
	return array;

}
//------------------------------------------------------------------------

-(void)populateGallery:(Gallery*)gallery{
	
	FMResultSet *rs = [db executeQuery:@"SELECT  * FROM algebraicsurfaces WHERE gallery_id = ?", [NSNumber numberWithInt:gallery.galID]];
	AlgebraicSurface* s = nil;
	NSMutableArray* surfacesArray = [[NSMutableArray alloc]init];

	if( !gallery.surfacesArray ){
		[gallery setSurfacesArray:surfacesArray];
	}else {
		[gallery.surfacesArray removeAllObjects];
	}

	while ([rs next]) {
	
		s = [[AlgebraicSurface alloc]init];
		
		[gallery.surfacesArray addObject:s];
		
		s.surfaceImage = [UIImage imageWithData:[rs dataForColumn:@"surfaceimage"]];
		s.surfaceDescription =  [rs stringForColumn:@"surfaceDescription"],
		s.surfaceName =   [rs stringForColumn:@"surfaceName"],
		s.equation =  [rs stringForColumn:@"equation"],

		[s release];
	}
	[surfacesArray release];
	[rs close];  	
}

//------------------------------------------------------------------------

@end
