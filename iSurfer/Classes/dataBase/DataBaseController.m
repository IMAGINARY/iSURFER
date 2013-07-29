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

-(UIImage*)loadImageFromFile:(NSString*)imagefileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imagefileName]; //Add the file name
    return [[UIImage alloc] initWithContentsOfFile:filePath];
}
//------------------------------------------------------------------------

-(void)saveImage:(UIImage*)image withName:(NSString*)imagename{
    if( image != NULL ){
        NSData *pngData = UIImagePNGRepresentation(image);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:imagename]; //Add the file name
        [pngData writeToFile:filePath atomically:YES]; //Write the file
    }
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
    
    [self saveImage: surface.surfaceImage withName:surface.realImageName];
    
    gal.thumbNail = surface.surfaceImage;
    
    [db executeUpdate:@"update galleries set thumbnail = ? where id = ?",
     imgdata,
     [NSNumber numberWithInt:gal.galID]];
    
	[db executeUpdate:@"insert into surfaces(equation, image, galleryid) values(?, ?, ?)",	
	 surface.equation,
	 imgdata,
	 [NSNumber numberWithInt:gal.galID]];
    //TODO
    
    [db executeUpdate:@"insert into galleries(thumbnail) values(?, ?)", imgdata];
    
    FMResultSet * rs = [db executeQuery:@"select max(id) as serial from surfaces"];
    [rs next];
    int serial = [rs intForColumn:@"serial"];
    
    surface.surfaceID = serial;

    [db executeUpdate:@"insert into surfacestexts (surfaceid, name, briefdescription, completedescription) values (?, ?, ?, ?)",
     [NSNumber numberWithInt:surface.surfaceID],
     surface.surfaceName,
     surface.briefDescription,
     surface.completeDescription];
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
    
    //NSString * query = [NSString stringWithFormat:@"%@%i%@%@%@%@%@", @"insert into galleriestexts (galleryid, name, description) values(", [NSNumber numberWithInt:gallery.galID].intValue, @",", gallery.galleryName, @",", gallery.galleryDescription, @")"];
    
    //NSLog(@"%d@", db.lastInsertRowId);
    //[db executeQuery:query];
    [db executeUpdate:@"insert into galleriestexts (galleryid, name, description) values (?, ?, ?)",[NSNumber numberWithInt:gallery.galID], gallery.galleryName, gallery.galleryDescription];
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
        
        int lang = [Language getLanguageIndex];
        
        //Only objects are used as query arguments
        
        NSString * query = [NSString stringWithFormat:@"%@%i%@%i", @"select name, description from galleriestexts where (language is null or language = ", [Language getLanguageIndex], @") and galleryid = ", [NSNumber numberWithInt:g.galID].intValue];
        
        FMResultSet *rstext = [db executeQuery:query];

//        FMResultSet *rstext = [db executeQuery:@"select name, description from galleriestexts where language = ? and galleryid = ?", [Language getLanguageIndex], [NSNumber numberWithInt:g.galID]];
        
        FMResultSet * count = [db executeQuery:@"SELECT count(*) as surfaces FROM surfaces WHERE galleryid = ? GROUP BY galleryid", [NSNumber numberWithInt:g.galID]];
        
        //This method has to be executed always
        [count next];
        [rstext next];
        
        g.surfacesNumber = [count intForColumn:@"surfaces"];
		g.galleryName = [rstext stringForColumn:@"name"];
		g.galleryDescription =  [rstext stringForColumn:@"description"];
        
        //NSLog(@"surfacesNumber %i", g.surfacesNumber);
        NSLog(@"galleryId %i", g.galID);
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
        
        NSString * query = [NSString stringWithFormat:@"%@%i%@%i", @"select name, briefdescription, completedescription from surfacestexts where (language is null or language = ", [Language getLanguageIndex], @") and surfaceid = ", [NSNumber numberWithInt:s.surfaceID].intValue];
        
        NSLog(@"Q%@", query);
        
        FMResultSet *rstext = [db executeQuery:query];
        
        [rstext next];
        
        //db executeQuery:@"select description from galleriestexts where galleryid = %d and language = 0", g.galID
        
        if(gallery.editable)
            s.surfaceImage = [UIImage imageWithData:[rs dataForColumn:@"image"]];
        else
            s.surfaceImage = [UIImage imageNamed:[rs stringForColumn:@"image"]];
        NSLog(@" %@",[rs stringForColumn:@"image"]);
        NSLog(@" %@",[s.surfaceImage description] );
        
//        NSLog(@"BD%@", [rstext stringForColumn:@"briefdescription"]);
//        NSLog(@"CD%@", [rstext stringForColumn:@"completedescription"]);
//        NSLog(@"N%@", [rstext stringForColumn:@"name"]);
//        NSLog(@"E%@", [rs stringForColumn:@"equation"]);
//        NSLog(@"RI%@", [rs stringForColumn:@"realimage"]);
        
		s.briefDescription =  [rstext stringForColumn:@"briefdescription"];
        s.completeDescription = [rstext stringForColumn:@"completedescription"];
		s.surfaceName =   [rstext stringForColumn:@"name"];
		s.equation =  [rs stringForColumn:@"equation"];
        s.realImageName = [rs stringForColumn:@"realimage"];
        
//        NSLog(@"%@", s.equation);
//        NSLog(@"%@", s.briefDescription);
//        NSLog(@"%@", s.completeDescription);
//        NSLog(@"%@", s.surfaceName);

		[s release];
	}
	[surfacesArray release];
	[rs close];  	
}

//------------------------------------------------------------------------

-(void) deleteSurface: (AlgebraicSurface*) surface{
    //TODO delete image
    [db executeUpdate:@"delete from surfaces where id = ?",
     [NSNumber numberWithInt: surface.surfaceID]];
    [db executeUpdate:@"delete from surfacestexts where surfaceid=?",
     [NSNumber numberWithInt: surface.surfaceID]];
    
    [db commit];
}

//------------------------------------------------------------------------

-(void) deleteGallery: (Gallery*) gallery{
    [db executeUpdate:@"delete from galleries where id = ?",
     [NSNumber numberWithInt: gallery.galID]];
    [db executeUpdate:@"delete from galleriestexts where galleryid=?",
     [NSNumber numberWithInt: gallery.galID]];
    
    [db commit];
}

//------------------------------------------------------------------------

@end
