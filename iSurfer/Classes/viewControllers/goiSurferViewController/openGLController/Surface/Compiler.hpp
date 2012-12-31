#ifndef __COMPILER_H__
#define __COMPILER_H__

#import <OpenGLES/ES2/gl.h>



/**
 * This module is written in C++. it is in charge
 of Creating and compilling the shaders, and render them.
  by dazar
 
 * Version: 3.0
 * @module Surface
 */

/** 
 * Last modified on December 5 2011 by dazar
 * -----------------------------------------------------
 * This interface provides access the shader compiler. It is in charge of generating all the shader code from the algebraic surface equation.
 * Then it compiles it to the GPU.
 * 
 * @class Compiler
 */



class Compiler
{
    
	public:
    
    /**
     * Usage: init(v1, f1,v2,f2,eq);
     * ----------------------------------
     * Generate the needed shader code from the equation, reads shader files 
     * and compile 1 or two programs depending on if wireSphere is active or not. 
     * @method init
     * @param vs1 {char *} vertex shader file name for isurfer.
     * @param fs1 {char *} fragment shader file name for isurfer.
     * @param fs2 {char *} fragment shader file name for wiresphere.
     * @param vs2 {char *} vertex shader file name for wiresphere.
     * @param formula {char *} surface formula.
     */
		static void init(const char *vs1, const char *fs1, const char *vs2, const char *fs2, const char * formula);


    
	private:
		static GLuint init( const char* vertex_shader_name, const char* fragment_shader_name );
        static GLuint initWire( const char* vertex_shader_name, const char* fragment_shader_name );

};

#endif
