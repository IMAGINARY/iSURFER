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

		BOOL success = [fileManager fileExistsAtPath:databasePath];
		
		if (!success) {
			
			NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_FILE_NAME];
			NSLog(@"%@", databasePathFromApp);
			[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
		}

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
	
	[db beginTransaction];
    
	NSData* imgdata = UIImagePNGRepresentation(surface.surfaceImage);
	   
    [self saveImage: surface.surfaceImage withName:surface.realImageName];
    
    gal.thumbNail = surface.surfaceImage;
    
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
    
    [db executeUpdate:@"update galleries set thumbnail = ? where id = ?",
     [NSNumber numberWithInt:surface.surfaceID],
     [NSNumber numberWithInt:gal.galID]];
    
//	FMDBQuickCheck([db hadError]);
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
	
    [db commit];
	
}

//------------------------------------------------------------------------

-(void)saveGallery:(Gallery*)gallery{
    if( gallery.saved ){
        return;
    }
    
	[db beginTransaction];
	NSData* imgdata = UIImagePNGRepresentation(gallery.thumbNail);

    gallery.editable = YES;
    
	[db executeUpdate:@"insert into galleries(editable, thumbnail) values(?, ?)",	
     [NSNumber numberWithInt: gallery.editable],
	 imgdata];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    FMResultSet *rs =[db executeQuery:@"select max(id) as serial from galleries"];
    [rs next];
    int serial = [rs intForColumn:@"serial"];
    gallery.galID = serial;
    [db executeUpdate:@"insert into galleriestexts (galleryid, name, description) values (?, ?, ?)",[NSNumber numberWithInt:gallery.galID], gallery.galleryName, gallery.galleryDescription];
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
	gallery.saved = YES;
    [db commit];
	
}

//------------------------------------------------------------------------

-(NSMutableArray*)getGalleries{
	NSLog(@"getGalleries");
	
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

        FMResultSet * count = [db executeQuery:@"SELECT count(*) as surfaces FROM surfaces WHERE galleryid = ? GROUP BY galleryid", [NSNumber numberWithInt:g.galID]];
        
        //This method has to be executed always
        [count next];
        [rstext next];
        
        g.surfacesNumber = [count intForColumn:@"surfaces"];
		g.galleryName = [rstext stringForColumn:@"name"];
		g.galleryDescription =  [rstext stringForColumn:@"description"];
        
            
		g.editable = [rs intForColumn:@"editable"];
        g.saved = YES;
        
		if( ![rs intForColumn:@"thumbnail"] ){
			g.thumbNail = [UIImage imageNamed:@"Imaginary_lemon.jpg"];
		}else {
            FMResultSet *surface_rs = [db executeQuery:@"SELECT * FROM surfaces WHERE id = ?", [NSNumber numberWithInt:[rs intForColumn:@"thumbnail"]]];
            [surface_rs next];
			UIImage* img = [UIImage imageWithData:[surface_rs dataForColumn:@"image"]];
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
                
        if(gallery.editable)
            s.surfaceImage = [UIImage imageWithData:[rs dataForColumn:@"image"]];
        else
            s.surfaceImage = [UIImage imageNamed:[rs stringForColumn:@"image"]];
        NSLog(@" %@",[rs stringForColumn:@"image"]);
        NSLog(@" %@",[s.surfaceImage description] );
                
		s.briefDescription =  [rstext stringForColumn:@"briefdescription"];
        s.completeDescription = [rstext stringForColumn:@"completedescription"];
		s.surfaceName =   [rstext stringForColumn:@"name"];
		s.equation =  [rs stringForColumn:@"equation"];
        s.realImageName = [rs stringForColumn:@"realimage"];
        
		[s release];
	}
	[surfacesArray release];
	[rs close];  	
}

//------------------------------------------------------------------------

-(void) deleteSurface: (AlgebraicSurface*) surface fromGallery: (Gallery *) gallery {
    [db beginTransaction];
    
    //TODO delete image
    [db executeUpdate:@"delete from surfaces where id = ?",
     [NSNumber numberWithInt: surface.surfaceID]];
    [db executeUpdate:@"delete from surfacestexts where surfaceid=?",
     [NSNumber numberWithInt: surface.surfaceID]];
    [db executeUpdate:@"update galleries set thumbnail = (select max(id) from surfaces where galleryid = ?) where id = ? ",
     [NSNumber numberWithInt: gallery.galID],
     [NSNumber numberWithInt: gallery.galID]];
    
    [db commit];
}

//------------------------------------------------------------------------

-(void) deleteGallery: (Gallery*) gallery{
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM surfaces WHERE galleryid = ?", [NSNumber numberWithInt:gallery.galID]];
    while ([rs next]) {
        int surfaceId = [rs intForColumn:@"id"];
        [db executeUpdate:@"delete from surfacestexts where surfaceid = ?", [NSNumber numberWithInt:surfaceId]];
        [db executeUpdate:@"delete from surfaces where id = ?", [NSNumber numberWithInt:surfaceId]];
    }
    [db executeUpdate:@"delete from galleries where id = ?",
     [NSNumber numberWithInt: gallery.galID]];
    [db executeUpdate:@"delete from galleriestexts where galleryid=?",
     [NSNumber numberWithInt: gallery.galID]];
    
    [db commit];
}

//------------------------------------------------------------------------

@end
