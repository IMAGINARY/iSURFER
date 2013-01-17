
/**
 * File: vs2.glsl
 * Version: 1.0
 * @module OpenGL
 */

/** 
 *Last modified on December 10 2011 by dazar
 * -----------------------------------------------------
 * This is the Fragment Shader to show the wire frame of the OpenGL Object.
 * @class Wire_Fragment_Shader
 */

/**
 * Usage: main(); 
 * --------------------------------------
 * Paints pixel in green.
 * @method main
 * @return {void}
 */
void main()
{
	gl_FragColor = vec4( 0.5, 1, 0.5, 1.0 );
}
