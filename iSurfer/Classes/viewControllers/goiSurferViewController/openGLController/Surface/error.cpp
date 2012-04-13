//
//  error.cpp
//  iSurfer
//
//  Created by Daniel Jose Azar on 4/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>

#import <OpenGLES/ES2/gl.h>

void error(const char *location, const char *msg)
{
	printf("Error at %s: %s\n", location, msg);
}

void checkGLError( const char *location )
{
	switch( glGetError() )
	{
		case GL_NO_ERROR:
			break;
		case GL_INVALID_ENUM:
			error( location, "GL_INVALID_ENUM" );
			break;
		case GL_INVALID_VALUE:
			error( location, "GL_INVALID_VALUE" );
			break;
		case GL_INVALID_OPERATION:
			error( location, "GL_INVALID_OPERATION" );
			break;
		case GL_INVALID_FRAMEBUFFER_OPERATION:
			error( location, "GL_INVALID_FRAMEBUFFER_OPERATION" );
			break;
		case GL_OUT_OF_MEMORY:
			error( location, "GL_OUT_OF_MEMORY" );
			break;
        default:
            error( location, "Uknown Error");
	}
}
