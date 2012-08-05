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
//	[fileManager removeItemAtPath:databasePath error:nil];

		BOOL success = [fileManager fileExistsAtPath:databasePath];
		
		if (!success) {
			
			NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_FILE_NAME];
			NSLog(@"%@", databasePathFromApp);
			[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
		}
		NSLog(@"%@", databasePath);

		//[fileManager release];
				
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
	
    NSLog(@"%@", surface.surfaceID);
    NSLog(@"%@", gal.galID);
    
	[db executeUpdate:@"insert into surfaces(name, equation, image, galleryid) values(?, ?, ?, ?, ?)",	
	 surface.surfaceName,
	 surface.equation,
	 imgdata,
	 [NSNumber numberWithInt:gal.galID]];
    //TODO
    [db executeUpdate:@"insert into surfacestexts (surfaceid, briefdescription, completedescription, language ) values (?, ?, ?, ?)",
     [NSNumber numberWithInt:surface.surfaceID],
     surface.briefDescription,
     surface.completeDescription,
     1];
//	FMDBQuickCheck([db hadError]);
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
	
    [db commit];
	
}

//------------------------------------------------------------------------

-(void)saveGallery:(Gallery*)gallery{
	NSLog(@"saveGallery");
    if( gallery.saved ){
        return;
    }
    
	[db beginTransaction];
	NSData* imgdata = UIImagePNGRepresentation(gallery.thumbNail);

    NSLog(@"%@", gallery);
    NSLog(@"%@", gallery.galleryName);
//    NSLog(@"%@", gallery.editable);
    NSLog(@"%@", imgdata);
    
	NSLog(@"%@", [db executeUpdate:@"insert into galleries (name, editable, thumbnail) values (?, ?, ?, ?)",	
	 gallery.galleryName,
	 gallery.editable, 
	 imgdata]);
    NSLog(@"%@", db.logsErrors);
    NSLog(@"%@", db.lastInsertRowId);
    [db executeUpdate:@"insert into galleriestext (galleryid, description, language) values (?,?,?)",
     [NSNumber numberWithInt:gallery.galID],
     gallery.galleryDescription,
     1];
//	FMDBQuickCheck([db hadError]);
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
	gallery.saved = YES;
    [db commit];
	
}
//------------------------------------------------------------------------

-(NSMutableArray*)getGalleries{
	NSLog(@"getGalleries");
	
	//FMResultSet *rs2 =	[db executeQuery:@"SELECT * FROM sqlite_master WHERE type='table'"];

	FMResultSet *rs = [db executeQuery:@"select id, name, editable, thumbnail from galleries"];
	Gallery* g = nil;
	NSMutableArray* array = [[[NSMutableArray alloc]init] autorelease];
	while ([rs next]) {
		g = [[Gallery alloc]init];
	
		g.galID = [rs intForColumn:@"id"];
        
        //Only objects are used as query arguments
        FMResultSet *rstext = [db executeQuery:@"select description from galleriestexts where language = 0 and galleryid = ? ", [NSNumber numberWithInt:g.galID]];
        
        //This methos has to be executed always
        [rstext next];
        
		g.galleryName = [rs stringForColumn:@"name"];
		g.galleryDescription =  [rstext stringForColumn:@"description"];
        
        NSLog(@"galleryDescription %@", g.galleryDescription);
        
		g.editable = [rs intForColumn:@"editable"];
        g.saved = YES;
		
		if( ![rs dataForColumn:@"thumbnail"] ){
			g.thumbNail = [UIImage imageNamed:@"Imaginary lemon.jpg"];
		}else {
			UIImage* img = [UIImage imageWithData:[rs dataForColumn:@"thumbnail"]];
			g.thumbNail = img;
		}


		// just print out what we've got in a number of formats.
		NSLog(@"%d %@ %@ %d",
			  [rs intForColumn:@"id"],
			  [rs stringForColumn:@"name"],
			  [rstext stringForColumn:@"description"],
			  [rs intForColumn:@"editable"]);
	
		[array addObject:g];
		[g release];
	}
	
	[rs close];  
	 
	return array;

}
//------------------------------------------------------------------------

-(void)populateGallery:(Gallery*)gallery{
	
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM surfaces WHERE galleryid = ?", [NSNumber numberWithInt:gallery.galID]];
    NSString * str = [NSString stringWithFormat:@"SELECT * FROM surfaces WHERE galleryid = ?", [NSNumber numberWithInt:gallery.galID]];
    //NSLog(@"lala: %@",[NSString stringWithFormat:@"%d", [rs columnIndexForName:@"id"]]);
    //NSLog(@"This string should end with NO: %@", [rs hasAnotherRow]?@"YES":@"NO");
    //NSLog(@"This string should end with YES:  %@", [rs next]?@"YES":@"NO");
    NSLog(@"%@", str);
	AlgebraicSurface* s = nil;
	NSMutableArray* surfacesArray = [[NSMutableArray alloc]init];

	[gallery removeAllSurfaces];
	while ([rs next]) {
	
		s = [[AlgebraicSurface alloc]init];
		
		[gallery addAlgebraicSurface:s];
        
        NSLog(@"lala: %@",[NSString stringWithFormat:@"%d", [rs intForColumnIndex:0]]);
        
        NSLog(@"%@", [NSString stringWithFormat:@"%d", [rs intForColumn:@"id"]]);
        
        s.surfaceID = [rs intForColumn:@"id"];
        
        FMResultSet *rstext = [db executeQuery:@"select briefdescription, completedescription from surfacestexts where language = 0 and surfaceid = ?", [NSNumber numberWithInt:s.surfaceID]];
        
        [rstext next];
        
        //db executeQuery:@"select description from galleriestexts where galleryid = %d and language = 0", g.galID
        
		s.surfaceImage = [UIImage imageWithData:[rs dataForColumn:@"surfaceimage"]];
        
        NSLog(@"%@", [rstext stringForColumn:@"briefdescription"]);
        NSLog(@"%@", [rstext stringForColumn:@"completedescription"]);
        NSLog(@"%@", [rs stringForColumn:@"name"]);
        NSLog(@"%@", [rs stringForColumn:@"equation"]);
        
		s.briefDescription =  [rstext stringForColumn:@"briefdescription"];
        s.completeDescription = [rstext stringForColumn:@"completedescription"];
		s.surfaceName =   [rs stringForColumn:@"name"];
		s.equation =  [rs stringForColumn:@"equation"];
        
        NSLog(@"%@", s.equation);
        NSLog(@"%@", s.briefDescription);
        NSLog(@"%@", s.completeDescription);
        NSLog(@"%@", s.surfaceName);

		[s release];
	}
	[surfacesArray release];
	[rs close];  	
}

//------------------------------------------------------------------------

@end
