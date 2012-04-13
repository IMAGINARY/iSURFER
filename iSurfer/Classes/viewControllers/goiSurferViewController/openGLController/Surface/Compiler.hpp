#ifndef __COMPILER_H__
#define __COMPILER_H__

#import <OpenGLES/ES2/gl.h>


class Compiler
{
    
	public:
        static void InitializeVertexBuffer();
		static void init(const char *vs1, const char *fs1, const char *vs2, const char *fs2, const char * formula);


    
	private:
		static GLuint init( const char* vertex_shader_name, const char* fragment_shader_name );
        static GLuint initWire( const char* vertex_shader_name, const char* fragment_shader_name );

};

#endif
