uniform highp mat4 modelviewMatrix;
uniform highp mat4 modelviewMatrixInverse;
uniform highp vec4 origin;

attribute vec4 pos;

varying highp vec3 varying_eye;
varying highp vec3 varying_dir;

/*
varying vec3 eye_space_eye;
varying vec3 eye_space_dir;
varying vec3 clipping_space_eye;
varying vec3 clipping_space_dir;
varying vec3 surface_space_eye;
varying vec3 surface_space_dir;
*/
void main( void )
{
	//vec4 origin = vec4( 0, 0, 0, 1.0 );
      //vec4 origin = vec4(       0,         0   ,10.7180,    1.0000);
    //vec4 origin = vec4( 0, 0, 1.0, 1.0 );
    
    gl_Position =  modelviewMatrix * pos;
	
	// calculate ray in different coordinate systems
	//varying_eye = ( modelviewMatrixInverse * origin ).xyz;

    varying_eye = ( modelviewMatrixInverse * origin ).xyz;
	varying_dir = pos.xyz - varying_eye;
    
    
    
    

    
       /* 
        // calculate ray in different coordinate systems
        eye_space_eye = ( gl_ModelViewMatrix * pos ).xyz;
        eye_space_dir = ( eye_space_eye );
        
        clipping_space_eye = gl_Vertex.xyz;
        clipping_space_dir = ( clipping_space_eye - ( modelviewMatrixInverse * vec4( 0.0, 0.0, 0.0, 1.0 ) ).xyz );
        
        surface_space_eye = ( surface_transform_inverse * gl_Vertex ).xyz;
        surface_space_dir = ( surface_space_eye - ( surface_transform_inverse * modelviewMatrixInverse * vec4( 0.0, 0.0, 0.0, 1.0 ) ).xyz );*/
    } 
