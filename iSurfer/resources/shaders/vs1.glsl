uniform mat4 modelviewMatrix;
uniform mat4 modelviewMatrixInverse;
uniform mat4 projectionMatrix;

attribute vec4 pos;

varying vec3 varying_eye;
varying vec3 varying_dir;

void main( void )
{
	vec4 origin = vec4( 0.0, 0.0, 0.0, 1.0 );
	gl_Position = projectionMatrix * modelviewMatrix * pos;
	
	// calculate ray in different coordinate systems
	varying_eye = ( modelviewMatrixInverse * origin ).xyz;
	varying_dir = pos.xyz - varying_eye;
}
