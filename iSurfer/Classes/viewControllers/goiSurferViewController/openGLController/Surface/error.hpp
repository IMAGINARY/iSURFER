//
//  error.h
//  iSurfer
//
//  Created by Daniel Jose Azar on 4/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#ifndef iSurfer_error_h
#define iSurfer_error_h


#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#define AT __FILE__ ":" TOSTRING(__LINE__)


/**
 * File: error.hpp
 * Version: 1.0
 * @module Surface
 */

/** 
 * Last modified on December 5 2011 by dazar
 * -----------------------------------------------------
 * This interface simplify reading GPU errors.
 * @class Error
 */

/**
 * Usage: checkGLError( AT );
 * ----------------------------------
 * Prints an error message depending on glGetError(). It also include the location, 
 * file and line number where the error was spotted. 

 * @method checkGLError
 * @param location {char *} vertex shader file name for isurfer.
  */

void checkGLError( const char *location );




#endif
