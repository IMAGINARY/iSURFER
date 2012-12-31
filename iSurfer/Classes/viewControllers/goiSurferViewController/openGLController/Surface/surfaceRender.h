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

/**
 * File: surfaceRender.h
 * Version: 1.0
 * @module Surface
 */

/** 
 * Last modified on December 5 2011 by dazar
 * -----------------------------------------------------
 * This interface is incharge of rendering a frame. 
 * It makes all the matrix necesary to render in Opengl.
 * @class surfaceRender
 */




class surfaceRender
{
public:
    /**
     * Usage: resize( w, h );
     * ----------------------------------
     * Resize OpenGl ViewPort. 
     * @method resize
     * @param w {int} viewPort wide. 
     * @param h {int} viewPort height. 
     */
    static void resize( int w, int h );

    /**
     * Usage: display( w, h );
     * ----------------------------------
     * Renders one frame.
     * @method display
     * @param drawable {Drawable} the drawable parametric Surface. 
     * @param Quaternion {Quaternion} device orientation. 
     */

    static void display(Drawable drawable, Quaternion orientation);
private:


};


#endif
