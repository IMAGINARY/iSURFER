uniform highp mat4 modelviewMatrix;
uniform highp mat4 modelviewMatrixInverse;
uniform highp vec4 origin;
uniform highp vec4 surface_transform_inverse;
attribute vec4 pos;
//attribute vec2 TextureCoord;

varying highp vec3 varying_eye;
varying highp vec3 varying_dir;
//varying vec2 TextureCoordOut;

/**
 * File: vs1.glsl
 * Version: 1.0
 * @module OpenGL
 */

/** 
 *Last modified on November 17 2012 by dazar
 * -----------------------------------------------------
 * This is the Vertex Shader. It is in charge of generating the necesary variables for the Ray Tracer in the Fragment Shader.
 * @class Vertex_Shader
 */

/**
 * Usage: main(); 
 * --------------------------------------
 * This method generates The eye position and direction for each Ray.
 * Then it execute at least one time the main method on the Fragment Shader for each Pixel on the screen inside a the camera projection.
 * @method main
 * @return {void}
 */
void main( void )
{
    gl_Position =  modelviewMatrix * pos;
	

    varying_eye = ( modelviewMatrixInverse * origin ).xyz;
	varying_dir = pos.xyz - varying_eye;
    //TextureCoordOut = TextureCoord;
    
    } 
