//
//  AlgebraicSurface.m
//  iSurfer
//
//  Created by Damian Modernell on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlgebraicSurface.h"


//TODO Considerar hacer una subclase de AlgebraicSurface para las imágenes de las galerías
//TODO Considerar no tener los atributos completeDescription y realImage en la superficie para ahorrar memoria a la hora de levantar todas las superficies. Considerar pedirlas cuando sea necesario, es decir, cuando se entra a la descripción completa de una superficie.
@implementation AlgebraicSurface
//--------------------------------------------------------------------------------------------------------
@synthesize surfaceID, surfaceImage, realImage, surfaceName, briefDescription, completeDescription, equation, saved;
//--------------------------------------------------------------------------------------------------------

-(id) init{	
	if (self = [super init]) {
        //Falta imagen real para la descripcion completa
		self.surfaceName = @"";
		self.briefDescription = @"";
        self.completeDescription = @"";
        self.equation = @"";
		self.surfaceImage = nil;
        self.realImage = nil;
        self.saved = NO;
	}
	return self;
}
//--------------------------------------------------------------------------------------------------------

-(void)dealloc{
	[surfaceName release];
	[briefDescription release];
    [completeDescription release];
	[surfaceImage release];
    [realImage release];
	[equation release];
	[super dealloc];
}
//--------------------------------------------------------------------------------------------------------
@end
