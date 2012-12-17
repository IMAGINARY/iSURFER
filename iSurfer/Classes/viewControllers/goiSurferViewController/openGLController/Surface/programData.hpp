#ifndef __PROGRAMDATA_H__
#define __PROGRAMDATA_H__


#import <OpenGLES/ES2/gl.h>
#import "Vector.hpp"
#include "Matrix.hpp"

#define STACKS 10
#define SLICES 10

struct ProgramHandle {
    GLuint attr_pos;
    GLint u_modelview;
    GLint u_modelview_inv;
    GLint u_projection;
    GLuint LightPosition;
    GLuint eye;
    GLuint LightPosition2;
    GLuint LightPosition3;
    GLint AmbientMaterial;
    GLint AmbientMaterial2;
    GLint SpecularMaterial;
    GLint SpecularMaterial2;
    GLint Shininess;
    GLint DiffuseMaterial;
    GLint DiffuseMaterial2;
    GLint Radius2;
    GLint wire_attr_pos;
    GLint wire_modelview;
    GLint wire_projection;
    GLuint vertexBuffer;
    GLuint wire_vertexBuffer;

};

struct ProgramIdentifiers {
    GLuint alg_surface_glsl_program;
    GLuint wireframe_glsl_program;
};

class programData
{
	public:
    
    
        //agregue los colorG2, etc para la segunda cara.
		static float rotationX, rotationY, rotationZ, Shininess, colorR, colorG, colorB, colorR2, colorG2, colorB2, lposX, lposY ,lposZ;
        //Estos son los parametros de tamaño de esfera, redius para zoom y los otros 2 para bajar la resolucion
        //default radius 1.0, slices y stacks 20;
        static float radius;
        static mat4 rot;
        static bool debug;
        static bool panoramic;
        static bool box;
        static int currentSurface, SurfaceCount;
        static ProgramHandle shaderHandle;
        static GLfloat vertex[STACKS*(SLICES+1)*2*3];
        static GLfloat normalized[STACKS*(SLICES+1)*2*3];
        static void InitializeProgramData();
    

    void OnFingerDown(ivec2 location);

    void static SetEye();

        void static UpdateColor(float red, float green, float blue);
        void static UpdateRadius(float Radius);
    static ProgramIdentifiers programs;

	private:
    
        void static setConstant();
        void static GenerateArrays();
};





#endif
