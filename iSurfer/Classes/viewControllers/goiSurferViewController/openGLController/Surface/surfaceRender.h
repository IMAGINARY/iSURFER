//
//  surfaceRender.h
//  iSurfer
//
//  Created by Daniel Jose Azar on 4/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#ifndef iSurfer_surfaceRender_h
#define iSurfer_surfaceRender_h

#include "Interfaces.hpp"

class surfaceRender
{
public:

    static void resize( int w, int h );
    
    static void display(Drawable drawable, Quaternion orientation);
	static void hola();
private:


};


#endif
