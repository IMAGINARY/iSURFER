uniform mat4 modelviewMatrix;

attribute vec4 pos;


/**
 * File: vs2.glsl
 * Version: 1.0
 * @module OpenGL
 */

/** 
 *Last modified on December 10 2011 by dazar
 * -----------------------------------------------------
 * This is the Vertex Shader to show the wire frame of the OpenGL Object.
 * @class Wire_Vertex_Shader
 */

/**
 * Usage: main(); 
 * --------------------------------------
 * Then it execute at least one time the main method on the Fragment Shader for each Pixel on the screen inside a the camera projection.
 * @method main
 * @return {void}
 */
 
void main()
{
	gl_Position = modelviewMatrix * pos;
}
