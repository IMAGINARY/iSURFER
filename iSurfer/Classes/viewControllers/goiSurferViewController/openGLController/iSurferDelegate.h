#ifndef __ISURFERDELEGATE_H__
#define __ISURFERDELEGATE_H__

#import <OpenGLES/ES2/gl.h>

class iSurferDelegate
{
	public:
		static float rotationX, rotationY, rotationZ;
	
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
