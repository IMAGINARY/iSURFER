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

void checkGLError( const char *location );




#endif
