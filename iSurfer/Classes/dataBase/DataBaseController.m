//
//  DataBaseController.m
//  iSurfer
//
//  Created by Damian Modernell on 10/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataBaseController.h"
#import "Language.h"
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
	
    //NSLog(@"%@", surface.surfaceID);
    NSLog(@"GalID %d", gal.galID);
    NSLog(@"GalName %@", gal.galleryName);
    NSLog(@"imagen:  %@", [surface.surfaceImage description]);
    /*
    NSString* date = [[NSDate date] description ];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@-%@-%@.png",rootPath, surface.surfaceName, gal.galleryName, date ];
	NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(surface.surfaceImage)];
	[data1 writeToFile:pngFilePath atomically:YES];
    
    */
    
	[db executeUpdate:@"insert into surfaces(equation, image, galleryid) values(?, ?, ?, ?)",	
	 surface.equation,
	 imgdata,
	 [NSNumber numberWithInt:gal.galID]];
    //TODO
    
    FMResultSet * rs = [db executeQuery:@"select max(id) as serial from surfaces"];
    [rs next];
    int serial = [rs intForColumn:@"serial"];
    
    surface.surfaceID = serial;
    [db commit];

    [db executeUpdate:@"insert into surfacestexts (surfaceid, name, briefdescription, completedescription, language) values (?, ?, ?, ?, ?)",
     [NSNumber numberWithInt:surface.surfaceID],
     surface.surfaceName,
     surface.briefDescription,
     surface.completeDescription,
     [NSNumber numberWithInt:1]];
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
    gallery.editable = YES;
    
	[db executeUpdate:@"insert into galleries(editable, thumbnail) values(?, ?)",	
     [NSNumber numberWithInt: gallery.editable],
	 imgdata];
//    NSLog(@"INSERT1 %@", db.logsErrors);
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    FMResultSet *rs =[db executeQuery:@"select max(id) as serial from galleries"];
    [rs next];
    int serial = [rs intForColumn:@"serial"];
    gallery.galID = serial;
    
    //NSLog(@"%d@", db.lastInsertRowId);
    [db executeUpdate:@"insert into galleriestexts (galleryid, name, description, language) values (?, ?, ?, ?)",
     [NSNumber numberWithInt:gallery.galID],
     gallery.galleryName,
     gallery.galleryDescription,
     [NSNumber numberWithInt: 1]];
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

	FMResultSet *rs = [db executeQuery:@"select id, editable, thumbnail from galleries"];
	Gallery* g = nil;
	NSMutableArray* array = [[[NSMutableArray alloc]init] autorelease];
	while ([rs next]) {
		g = [[Gallery alloc]init];
	
		g.galID = [rs intForColumn:@"id"];
        
        NSString * lang = [Language getCurrentLang];
        
        //Only objects are used as query arguments
        FMResultSet *rstext = [db executeQuery:@"select name, description from galleriestexts where language = 0 and galleryid = ?", [NSNumber numberWithInt:g.galID]];
        
        FMResultSet * count = [db executeQuery:@"SELECT count(*) as surfaces FROM surfaces WHERE galleryid = ? GROUP BY galleryid", [NSNumber numberWithInt:g.galID]];
        
        //This method has to be executed always
        [count next];
        [rstext next];
        
        g.surfacesNumber = [count intForColumn:@"surfaces"];
		g.galleryName = [rstext stringForColumn:@"name"];
		g.galleryDescription =  [rstext stringForColumn:@"description"];
        
        NSLog(@"galleryName %@", g.galleryName);
        NSLog(@"galleryDescription %@", g.galleryDescription);
        
		g.editable = [rs intForColumn:@"editable"];
        g.saved = YES;
		
		if( ![rs dataForColumn:@"thumbnail"] ){
			g.thumbNail = [UIImage imageNamed:@"Imaginary_lemon.jpg"];
		}else {
			UIImage* img = [UIImage imageWithData:[rs dataForColumn:@"thumbnail"]];
			g.thumbNail = img;
		}


		// just print out what we've got in a number of formats.
		NSLog(@"id:%d name:%@ description:%@ editable:%d",
			  [rs intForColumn:@"id"],
			  [rstext stringForColumn:@"name"],
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
    NSLog(@"POPULATE%@", str);
	AlgebraicSurface* s = nil;
	NSMutableArray* surfacesArray = [[NSMutableArray alloc]init];

	[gallery removeAllSurfaces];
	while ([rs next]) {
	
		s = [[AlgebraicSurface alloc]init];
		
		[gallery addAlgebraicSurface:s];
        
        NSLog(@"lala: %@",[NSString stringWithFormat:@"%d", [rs intForColumnIndex:0]]);
        
        NSLog(@"%@", [NSString stringWithFormat:@"%d", [rs intForColumn:@"id"]]);
        
        s.surfaceID = [rs intForColumn:@"id"];
        
        FMResultSet *rstext = [db executeQuery:@"select name, briefdescription, completedescription from surfacestexts where language = 0 and surfaceid = ?", [NSNumber numberWithInt:s.surfaceID]];
        
        [rstext next];
        
        //db executeQuery:@"select description from galleriestexts where galleryid = %d and language = 0", g.galID
        
		s.surfaceImage = [UIImage imageWithData:[rs dataForColumn:@"image"]];
        NSLog(@" %@",[s.surfaceImage description] );
        
        NSLog(@"%@", [rstext stringForColumn:@"briefdescription"]);
        NSLog(@"%@", [rstext stringForColumn:@"completedescription"]);
        NSLog(@"%@", [rstext stringForColumn:@"name"]);
        NSLog(@"%@", [rs stringForColumn:@"equation"]);
        
		s.briefDescription =  [rstext stringForColumn:@"briefdescription"];
        s.completeDescription = [rstext stringForColumn:@"completedescription"];
		s.surfaceName =   [rstext stringForColumn:@"name"];
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
