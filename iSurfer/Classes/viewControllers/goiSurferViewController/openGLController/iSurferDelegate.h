#ifndef __ISURFERDELEGATE_H__
#define __ISURFERDELEGATE_H__

#import <OpenGLES/ES2/gl.h>

class iSurferDelegate
{
	public:
        //agregue los colorG2, etc para la segunda cara.
		static float rotationX, rotationY, rotationZ, lightIntensity, colorR, colorG, colorB, colorR2, colorG2, colorB2, lposX, lposY ,lposZ;
        //Estos son los parametros de tamaño de esfera, redius para zoom y los otros 2 para bajar la resolucion
        //default radius 1.0, slices y stacks 20;
        static float radius, slices, stacks;
		static void init(const char *vs1, const char *fs1, const char *vs2, const char *fs2, const char * formula);
		
		static void resize( int w, int h );
		
		static void display();
		static void display2();
	
	private:
		static void set_light_and_material();
		static GLuint init( const char* vertex_shader_name, const char* fragment_shader_name );

		static GLuint alg_surface_glsl_program;
		static GLuint wireframe_glsl_program;
};

#endif
