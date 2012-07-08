uniform highp mat4 modelviewMatrix;
uniform highp mat4 modelviewMatrixInverse;
//uniform highp vec3 varying_eye;

attribute vec4 pos;

varying highp vec3 varying_eye;
varying highp vec3 varying_dir;

void main( void )
{
	vec4 origin = vec4( 0, 0, 0, 1.0 );
//      vec4 origin = vec4(       0,         0   ,10.7180,    1.0000);
    //vec4 origin = vec4( 0, 0, 1.0, 1.0 );
    gl_Position =  modelviewMatrix * pos;
	
	// calculate ray in different coordinate systems
	varying_eye = ( modelviewMatrixInverse * origin ).xyz;
	varying_dir = pos.xyz - varying_eye;
} 
