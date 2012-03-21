#include "iSurferDelegate.h"
#include "matrix.h"

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

extern "C" {
#include <stdio.h>
#include "genlib.h"
#include "strlib.h"
#include "simpio.h"
#include "exp.h"
#include "scanadt.h"
#include "parser.h"
}

#define STACKS 20
#define SLICES 20
float iSurferDelegate::rotationX = 0.0f;
float iSurferDelegate::rotationY = 0.0f;
float iSurferDelegate::rotationZ = M_PI_2;
float iSurferDelegate::Shininess = 0.20f;
float iSurferDelegate::colorR = 0.5f;
float iSurferDelegate::colorG = 0.4f;
float iSurferDelegate::colorB = 0.8f;
float iSurferDelegate::colorR2 = 0.9f;
float iSurferDelegate::colorG2 = 0.5f;
float iSurferDelegate::colorB2 = 0.6f;
float iSurferDelegate::lposX = 5.0f;
float iSurferDelegate::lposY = 5.0f;
float iSurferDelegate::lposZ = 1.0f;
float iSurferDelegate::stacks = STACKS;
float iSurferDelegate::slices = SLICES;
float iSurferDelegate::radius = 5;
expressionT expt;
bool debug = true;
bool box = false;

GLfloat v[STACKS*(SLICES+1)*2*3];
GLfloat n[STACKS*(SLICES+1)*2*3];



GLuint iSurferDelegate::alg_surface_glsl_program = 0u;
GLuint iSurferDelegate::wireframe_glsl_program = 0u;

struct UniformHandles {
    GLuint LightPosition;
    GLuint LightPosition2;
    GLuint LightPosition3;
    GLint AmbientMaterial;
    GLint AmbientMaterial2;
    GLint SpecularMaterial;
    GLint SpecularMaterial2;
    GLint Shininess;
    GLint DiffuseMaterial;
    GLint Radius2;
};
UniformHandles m_uniforms;

template <typename T>
struct Vector4 {
    Vector4() {}
    Vector4(T x, T y, T z, T w) : x(x), y(y), z(z), w(w) {}
    T Dot(const Vector4& v) const
    {
        return x * v.x + y * v.y + z * v.z + w * v.w;
    }
    Vector4 Lerp(float t, const Vector4& v) const
    {
        return Vector4(x * (1 - t) + v.x * t,
                       y * (1 - t) + v.y * t,
                       z * (1 - t) + v.z * t,
                       w * (1 - t) + v.w * t);
    }
    const T* Pointer() const
    {
        return &x;
    }
    T x;
    T y;
    T z;
    T w;
};

typedef Vector4<float> vec4;


using namespace std;

void solidSphere( GLfloat radius, GLint slices, GLint stacks, GLuint attr_pos );
void wireSphere( GLfloat radius, GLint slices, GLint stacks, GLuint attr_pos );
void wireBox( GLfloat radius, GLuint attr_pos );
string read_file( string filename );
void printShaderInfoLog( GLuint obj );
void printProgramInfoLog( GLuint obj );
	
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#define AT __FILE__ ":" TOSTRING(__LINE__)
void error(const char *location, const char *msg)
{
	printf("Error at %s: %s\n", location, msg);
}

void checkGLError( const char *location )
{
	switch( glGetError() )
	{
		case GL_NO_ERROR:
			break;
		case GL_INVALID_ENUM:
			error( location, "GL_INVALID_ENUM" );
			break;
		case GL_INVALID_VALUE:
			error( location, "GL_INVALID_VALUE" );
			break;
		case GL_INVALID_OPERATION:
			error( location, "GL_INVALID_OPERATION" );
			break;
		case GL_INVALID_FRAMEBUFFER_OPERATION:
			error( location, "GL_INVALID_FRAMEBUFFER_OPERATION" );
			break;
		case GL_OUT_OF_MEMORY:
			error( location, "GL_OUT_OF_MEMORY" );
			break;
	}
}

void iSurferDelegate::init(const char *vs1, const char *fs1, const char *vs2, const char *fs2, const char *formula)
{
    
	checkGLError( AT );
	scannerADT scanner;
    scanner= NewScanner();
    SetScannerSpaceOption(scanner, IgnoreSpaces);
	
	SetScannerString(scanner, (char *)formula);
	expt= ParseExp(scanner);
	clearExp();
	EvalExp(expt, 0);
    EvalDerivateNoCode(expt);
    EvalDegree(expt);

    FreeScanner(scanner);
    if(ErrorExist()){
      printf("%s", getErrorMsg());  
        return ;
        
    }
    // no se si va    
    FreeTree(expt);

    glDeleteShader(alg_surface_glsl_program);
    //printf("code\n");
	//printf(getCode());
    //printf("\nderivate\n");
    //printf(getCodeDerivate());
    //printf("\nderivate\n");
    
	//printf("\n");
	//printf("Degree %d \n", EvalDegree(exp));
	
	alg_surface_glsl_program = init( vs1/*"vs1.glsl"*/, fs1/*"fs1.glsl"*/ );
    if(debug){
        glDeleteShader(wireframe_glsl_program);
        wireframe_glsl_program = initWire( vs2/*"vs2.glsl"*/, fs2/*"fs2.glsl"*/ );
    }
	checkGLError( AT );
    
}

GLuint iSurferDelegate::init( const char* vertex_shader_name, const char* fragment_shader_name )
{
	GLint error_code;

	// create, load and compile vertex shader 
	GLuint vertex_shader = glCreateShader( GL_VERTEX_SHADER );
	string vertex_shader_code = read_file( vertex_shader_name );
	const char *vertex_shader_code_c_str = vertex_shader_code.c_str();
	glShaderSource( vertex_shader, 1, &vertex_shader_code_c_str, NULL );
	glCompileShader( vertex_shader );

	{
		glGetShaderiv( vertex_shader, GL_COMPILE_STATUS, &error_code );

		if( error_code == GL_FALSE )
		{
			printf( "Error during Vertex Shader \"%s\" compilation:\n", vertex_shader_name );
			printShaderInfoLog( vertex_shader );
			return 0;
		}
		else
		{
			printf( "Vertex Shader \"%s\" successfully compiled.\n", vertex_shader_name );
		}
	}

	// create, load and compile fragment shader 
	GLuint fragment_shader = glCreateShader( GL_FRAGMENT_SHADER );
	string fragment_shader_code = read_file( fragment_shader_name );
	const char *fragment_shader_code_c_str = fragment_shader_code.c_str();
	int codeLen = strlen(getCode());
	int shaderLen = strlen(fragment_shader_code_c_str);
    int derivLen = strlen(getCodeDerivate()); 
    char degre[10];
    sprintf(degre, "%d ", getDegree());
    //printf("\n degree %s \n", degre);

    int degreLen = strlen(degre);
	char * shader_code_c_str = (char *) malloc( shaderLen + codeLen + derivLen + degreLen + 2) ;
    int degrePosition = 15 + FindString((char *) "#define DEGREE ", (char * )fragment_shader_code_c_str, 1);;
	int position = 7 + FindString((char *) "return ", (char * )fragment_shader_code_c_str, 1);
	int positionDerivate = 13 + FindString((char *) "highp vec3 N ", (char * )fragment_shader_code_c_str, 1);
    memcpy(shader_code_c_str , fragment_shader_code_c_str, degrePosition);
    char * fragment_shader_code_c_str_aux =  (char *) fragment_shader_code_c_str + degrePosition; 
    char * shader_code_c_str_aux = shader_code_c_str + degrePosition;
	int posDer = positionDerivate  - position;
    position -= degrePosition;

	memcpy(shader_code_c_str_aux, degre, degreLen);

	shader_code_c_str_aux += degreLen;
    
    memcpy(shader_code_c_str_aux , fragment_shader_code_c_str_aux, position );
    shader_code_c_str_aux += position;
    fragment_shader_code_c_str_aux += position ;
	memcpy(shader_code_c_str_aux , getCode(), codeLen);
    shader_code_c_str_aux += codeLen;
    
    memcpy(shader_code_c_str_aux, fragment_shader_code_c_str_aux, posDer  );
    fragment_shader_code_c_str_aux += posDer;
    shader_code_c_str_aux += posDer;
    
    memcpy(shader_code_c_str_aux , getCodeDerivate() , derivLen );
    shader_code_c_str_aux += derivLen;
	
    memcpy(shader_code_c_str_aux, fragment_shader_code_c_str_aux , shaderLen  - positionDerivate );
    shader_code_c_str_aux += shaderLen - positionDerivate;
  
    shader_code_c_str_aux[0] = '\0';

	//printf("\n\n\n\n\n%s\n\n\n\n\n\n\n", shader_code_c_str);
	fflush(stdout);
	//printf("\nhola\n");
    const char *Frafmentshader_code_c_str = (const char *)shader_code_c_str;
	glShaderSource( fragment_shader, 1, &Frafmentshader_code_c_str, NULL );
	glCompileShader( fragment_shader );

	free(shader_code_c_str);
	
	{
		glGetShaderiv( fragment_shader, GL_COMPILE_STATUS, &error_code );
		if( error_code == GL_FALSE )
		{
			printf( "Error during Fragment Shader \"%s\" compilation:\n", fragment_shader_name );
			printShaderInfoLog( fragment_shader );
			return 0;
		}
		else
		{
			printf( "Fragment Shader \"%s\" successfully compiled.\n", fragment_shader_name );
		}
	}
	
	GLuint glsl_program = glCreateProgram();
	glAttachShader( glsl_program, vertex_shader );
	glAttachShader( glsl_program, fragment_shader );
	glLinkProgram( glsl_program );

	{
		glGetProgramiv( glsl_program, GL_LINK_STATUS, &error_code );
		if( error_code == GL_FALSE )
		{
			printf( "Error during GLSL program %i linking.\n", glsl_program );
			printProgramInfoLog( glsl_program );
			return 0;
		}
		else
		{
			printf( "GLSL program %u successfully linked.\n", glsl_program );
		}
	}

	glValidateProgram( glsl_program );

	{
		glGetProgramiv( glsl_program, GL_VALIDATE_STATUS, &error_code );
		if( error_code == GL_FALSE )
		{
			printf( "Error during GLSL program %i validation.\n", glsl_program );
			printProgramInfoLog( glsl_program );
			return 0;
		}
	}
//	printf( "\n" );

	glUseProgram( glsl_program );
	return glsl_program;
}


GLuint iSurferDelegate::initWire( const char* vertex_shader_name, const char* fragment_shader_name )
{
	GLint error_code;
    
	// create, load and compile vertex shader 
	GLuint vertex_shader = glCreateShader( GL_VERTEX_SHADER );
	string vertex_shader_code = read_file( vertex_shader_name );
	const char *vertex_shader_code_c_str = vertex_shader_code.c_str();
	glShaderSource( vertex_shader, 1, &vertex_shader_code_c_str, NULL );
	glCompileShader( vertex_shader );
    
	{
		glGetShaderiv( vertex_shader, GL_COMPILE_STATUS, &error_code );
        
		if( error_code == GL_FALSE )
		{
			printf( "Error during Vertex Shader \"%s\" compilation:\n", vertex_shader_name );
			printShaderInfoLog( vertex_shader );
			return 0;
		}
		else
		{
			printf( "Vertex Shader \"%s\" successfully compiled.\n", vertex_shader_name );
		}
	}
    
	// create, load and compile fragment shader 
	GLuint fragment_shader = glCreateShader( GL_FRAGMENT_SHADER );
	string fragment_shader_code = read_file( fragment_shader_name );
	const char *fragment_shader_code_c_str = fragment_shader_code.c_str();
	glShaderSource( fragment_shader, 1, &fragment_shader_code_c_str, NULL );
	glCompileShader( fragment_shader );
    
	{
		glGetShaderiv( fragment_shader, GL_COMPILE_STATUS, &error_code );
		if( error_code == GL_FALSE )
		{
			printf( "Error during Fragment Shader \"%s\" compilation:\n", fragment_shader_name );
			printShaderInfoLog( fragment_shader );
			return 0;
		}
		else
		{
			printf( "Fragment Shader \"%s\" successfully compiled.\n", fragment_shader_name );
		}
	}
	
	GLuint glsl_program = glCreateProgram();
	glAttachShader( glsl_program, vertex_shader );
	glAttachShader( glsl_program, fragment_shader );
	glLinkProgram( glsl_program );
    
	{
		glGetProgramiv( glsl_program, GL_LINK_STATUS, &error_code );
		if( error_code == GL_FALSE )
		{
			printf( "Error during GLSL program %i linking.\n", glsl_program );
			printProgramInfoLog( glsl_program );
			return 0;
		}
		else
		{
			printf( "GLSL program %u successfully linked.\n", glsl_program );
		}
	}
    
	glValidateProgram( glsl_program );
    
	{
		glGetProgramiv( glsl_program, GL_VALIDATE_STATUS, &error_code );
		if( error_code == GL_FALSE )
		{
			printf( "Error during GLSL program %i validation.\n", glsl_program );
			printProgramInfoLog( glsl_program );
			return 0;
		}
	}
    
	glUseProgram( glsl_program );
    
	return glsl_program;
}


void iSurferDelegate::resize( int w, int h )
{
	// always use quadratic viewport
	if( w > h )
		glViewport( 0, 0, (GLsizei) h, (GLsizei) h );
	else
		glViewport( 0, 0, (GLsizei) w, (GLsizei) w );	
}

void iSurferDelegate::display()
{
	checkGLError( AT );
    //printf("Display empieza \n");
	// setup matrices
	Matrix4x4 t, s, rx, ry, rz, modelview, modelview_inv;
	//Para el zoom parametrizar scale_matrix
	//Para rotacion setear las variables de rotation_matrix
	//Traslacion si es necesario usar la matriz
    scale_matrix( 1, 1, 1, s );
    
	translation_matrix( 0.0, 0.0, -500 , t );

	rotation_matrix( 1.0f, 0.0f, 0.0f, iSurferDelegate::rotationX, rx );
	rotation_matrix( 0.0f, 1.0f, 0.0f, iSurferDelegate::rotationY, ry );
	rotation_matrix( 0.0f, 0.0f, 1.0f, iSurferDelegate::rotationZ, rz );

	mult_matrix( t, s, modelview );
	mult_matrix( modelview, rx, modelview );
	mult_matrix( modelview, ry, modelview );
	mult_matrix( modelview, rz, modelview );
	
	invert_matrix( modelview, modelview_inv );

	Matrix4x4 projection;

    ortho(radius, 0.1, 2000, projection);
    printf("radius = %f\n", radius);
    printf("Rotaxion x = %f, y=%f, z=%f \n", rotationX, rotationY, rotationZ);
    
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT ); checkGLError( AT );

	// enable blending
	glEnable (GL_BLEND);
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

	// set culling properties
	glFrontFace( GL_CCW );
	glCullFace( GL_BACK );

    if(debug)
	// draw wireframe sphere
	{
        glDisable( GL_CULL_FACE );
        
        GLuint glsl_program = wireframe_glsl_program;
        glUseProgram( glsl_program ); checkGLError( AT );
        
        GLint attr_pos = glGetAttribLocation( glsl_program, "pos" ); checkGLError( AT );
        
        GLint u_modelview = glGetUniformLocation( glsl_program, "modelviewMatrix" ); checkGLError( AT );
        GLint u_projection = glGetUniformLocation( glsl_program, "projectionMatrix" ); checkGLError( AT );
        
        glUniformMatrix4fv( u_modelview, 1, GL_FALSE, modelview ); checkGLError( AT );
        glUniformMatrix4fv( u_projection, 1, GL_FALSE, projection ); checkGLError( AT );

        if(box) 
        {
            wireBox( radius, attr_pos ); checkGLError( AT );
        }
        else
        {
            wireSphere( radius, 20, 20, attr_pos ); checkGLError( AT );
        }
	}
	// draw solid sphere, which is used for raycasting
	{
		glEnable( GL_CULL_FACE );

		GLuint glsl_program = alg_surface_glsl_program;
		glUseProgram( glsl_program ); checkGLError( AT );

		GLint attr_pos = glGetAttribLocation( glsl_program, "pos" ); checkGLError( AT );

		GLint u_modelview = glGetUniformLocation( glsl_program, "modelviewMatrix" ); checkGLError( AT );
		GLint u_modelview_inv = glGetUniformLocation( glsl_program, "modelviewMatrixInverse" ); checkGLError( AT );
		GLint u_projection = glGetUniformLocation( glsl_program, "projectionMatrix" ); checkGLError( AT );

        m_uniforms.Radius2 = glGetUniformLocation(glsl_program, "radius2");
        m_uniforms.LightPosition = glGetUniformLocation(glsl_program, "LightPosition");
        m_uniforms.LightPosition2 = glGetUniformLocation(glsl_program, "LightPosition2");
        m_uniforms.LightPosition3 = glGetUniformLocation(glsl_program, "LightPosition3");
        m_uniforms.AmbientMaterial = glGetUniformLocation(glsl_program, "AmbientMaterial");
        m_uniforms.AmbientMaterial2 = glGetUniformLocation(glsl_program, "AmbientMaterial2");
        m_uniforms.SpecularMaterial = glGetUniformLocation(glsl_program, "SpecularMaterial");
        m_uniforms.SpecularMaterial2 = glGetUniformLocation(glsl_program, "SpecularMaterial2");
        m_uniforms.Shininess = glGetUniformLocation(glsl_program, "Shininess"); 
        m_uniforms.DiffuseMaterial = glGetAttribLocation(glsl_program, "Diffuse");
        
        glUniform1f(m_uniforms.Radius2, radius* radius);

        //Color ambient, sin luz
        float div = 4.0f;
        glUniform3f(m_uniforms.AmbientMaterial, colorR / div, colorG /div, colorB / div);
        glUniform3f(m_uniforms.AmbientMaterial2, colorR2 / div, colorG2 /div, colorB2 / div);
        //R,G,B, alpha con luz
        glUniform3f(m_uniforms.SpecularMaterial, colorR, colorG, colorB);
        glUniform3f(m_uniforms.SpecularMaterial2, colorR2, colorG2, colorB2);

        //Power de la luz
        glUniform1f(m_uniforms.Shininess, Shininess);
        vec4 lightPosition(radius, radius, 0, 0);
        glUniform3fv(m_uniforms.LightPosition, 1, lightPosition.Pointer());
        //vec4 lightPosition2(-1, 0, -200, 0);
        vec4 lightPosition2(0, -radius, radius, 0);
        
        glUniform3fv(m_uniforms.LightPosition2, 1, lightPosition2.Pointer());

        vec4 lightPosition3(-radius, -radius, -radius, 0);
        glUniform3fv(m_uniforms.LightPosition3, 1, lightPosition3.Pointer());

        glUniform3f(m_uniforms.DiffuseMaterial, colorR, colorG, colorB);


		glUniformMatrix4fv( u_modelview, 1, GL_FALSE, modelview ); checkGLError( AT );
		glUniformMatrix4fv( u_modelview_inv, 1, GL_FALSE, modelview_inv ); checkGLError( AT );
		glUniformMatrix4fv( u_projection, 1, GL_FALSE, projection ); checkGLError( AT );
        
		solidSphere( radius, slices, stacks, attr_pos ); checkGLError( AT );

	}
	checkGLError( AT );
    
    //printf("Termino Display\n");

}

void iSurferDelegate::display2()
{
	// reset modelview transformation
	//glMatrixMode( GL_MODELVIEW );
	//glLoadIdentity();
	//gluLookAt( 0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0 );	

	// enable backface culling
	glFrontFace( GL_CCW );
	glEnable( GL_CULL_FACE );
	glCullFace( GL_BACK );

	// enable blending
	glEnable (GL_BLEND);
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

	// clear depth buffer
	glClearColor( 0.0, 0.0, 0.0, 1.0 );
	glClear( GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT );
	glEnable( GL_DEPTH_TEST );

	// enable fixed function rendering
//	glUseProgram( 0 );

	// move clipping object to desired position
	//glMatrixMode( GL_MODELVIEW );
	//glTranslatef( 0.0f, 0.0f, -7.5f );
	
	//glRotatef( rotationX, 1.0, 0.0, 0.0 );
	//glRotatef( rotationY, 0.0, 1.0, 0.0 );
	//glRotatef( rotationZ, 0.0, 0.0, 1.0 );

	


/*
	// apply local transformation (i.e. rotation)
	bbox_transform.glMultMatrix();

	// apply transformation to surface
	sm->set_surface_transformation( surface_transform );
*/
	// scale surrounding box
	//glScalef( 3.55f, 3.55f, 3.55f );
/*
	if( sm->get_clipping_surface() == ShaderManager::CUBE )		
		glScaled( 1.0 / 1.73205, 1.0 / 1.73205, 1.0 / 1.73205 );
*/
	// draw wireframe sphere "behind" algebraic surface
	glCullFace( GL_FRONT );
	//glColor4f( 1.0, 1.0, 1.0, 1.0 );
//	glColor4f( 0.5, 0.5, 0.5, 0.5 );
	//solidSphere( 1.0, 20, 20 );

/*
	// use raytrace shader
	glUseProgram( glsl_program );

	// raytrace in surrounding box ( size: 2x2x2 )
	glDepthFunc( GL_LEQUAL );
	solidCube( 2.0 );
*/
}


	void PlotSpherePoints(GLfloat radius, GLint stacks, GLint slices, GLfloat *v, GLfloat *n )
	{

		GLint i, j; 
		GLfloat slicestep, stackstep;

		stackstep = ((GLfloat)M_PI) / stacks;
		slicestep = 2.0f * ((GLfloat)M_PI) / slices;

		for (i = 0; i < stacks; ++i)		
		{
			GLfloat a = i * stackstep;
			GLfloat b = a + stackstep;

			GLfloat s0 =  (GLfloat)sin(a);
			GLfloat s1 =  (GLfloat)sin(b);

			GLfloat c0 =  (GLfloat)cos(a);
			GLfloat c1 =  (GLfloat)cos(b);

			for (j = 0; j <= slices; ++j)		
			{
				GLfloat c = j * slicestep;
				GLfloat x = (GLfloat)cos(c);
				GLfloat y = (GLfloat)sin(c);

				*n = x * s0;
				*v = *n * radius;

				n++;
				v++;

				*n = y * s0;
				*v = *n * radius;

				n++;
				v++;

				*n = c0;
				*v = *n * radius;

				n++;
				v++;

				*n = x * s1;
				*v = *n * radius;

				n++;
				v++;

				*n = y * s1;
				*v = *n * radius;

				n++;
				v++;

				*n = c1;
				*v = *n * radius;

				n++;
				v++;

			}
		}
	}

typedef struct {
    float Position[3];
} Vertex;

/*const Vertex Vertices[] = {
 {{1, -1, 0}, {1, 0, 0, 1}},
 {{1, 1, 0}, {0, 1, 0, 1}},
 {{-1, 1, 0}, {0, 0, 1, 1}},
 {{-1, -1, 0}, {0, 0, 0, 1}}
 };
 
 const GLubyte Indices[] = {
 0, 1, 2,
 2, 3, 0
 };*/


const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 7, 6,
    // Left
    2, 7, 3,
    7, 6, 2,
    // Right
    0, 4, 1,
    4, 1, 5,
    // Top
    6, 2, 1, 
    1, 6, 5,
    // Bottom
    0, 3, 7,
    0, 7, 4    
};


void PlotBoxPoints(GLfloat radius,  GLfloat *v )
{
    // Front
    
    //0
        *v = radius; v++;
        *v = -radius; v++;
        *v = radius; v++;
    //1
        *v = radius; v++;
        *v = radius; v++;
        *v = radius; v++;
    //2
        *v = -radius; v++;
        *v = radius; v++;
        *v = radius; v++;
    //3
        *v = -radius; v++;
        *v = -radius; v++;
        *v = radius; v++;

    //2
    *v = -radius; v++;
    *v = radius; v++;
    *v = radius; v++;
    //3
    *v = -radius; v++;
    *v = -radius; v++;
    *v = radius; v++;

    //0
    *v = radius; v++;
    *v = -radius; v++;
    *v = radius; v++;

    // Back
    //4
        *v = radius; v++;
        *v = -radius; v++;
        *v = -radius; v++;
    //6
    *v = -radius; v++;
    *v = radius; v++;
    *v = -radius; v++;
    //5
        *v = radius; v++;
        *v = radius; v++;
        *v = -radius; v++;

    //4
    *v = radius; v++;
    *v = -radius; v++;
    *v = -radius; v++;
    //7
    *v = -radius; v++;
    *v = -radius; v++;
    *v = -radius; v++;
    //6
    *v = -radius; v++;
    *v = radius; v++;
    *v = -radius; v++;
    //LEFT
    //2
    *v = -radius; v++;
    *v = radius; v++;
    *v = radius; v++;
    //7
    *v = -radius; v++;
    *v = -radius; v++;
    *v = -radius; v++;

    //3
    *v = -radius; v++;
    *v = -radius; v++;
    *v = radius; v++;

    //7
    *v = -radius; v++;
    *v = -radius; v++;
    *v = -radius; v++;
    //6
    *v = -radius; v++;
    *v = radius; v++;
    *v = -radius; v++;
    //2
    *v = -radius; v++;
    *v = radius; v++;
    *v = radius; v++;

    // Right
    //0
    *v = radius; v++;
    *v = -radius; v++;
    *v = radius; v++;
    //4
    *v = radius; v++;
    *v = -radius; v++;
    *v = -radius; v++;

    //1
    *v = radius; v++;
    *v = radius; v++;
    *v = radius; v++;

    //4
    *v = radius; v++;
    *v = -radius; v++;
    *v = -radius; v++;
    //1
    *v = radius; v++;
    *v = radius; v++;
    *v = radius; v++;

    //5
    *v = radius; v++;
    *v = radius; v++;
    *v = -radius; v++;

    // Top
    //6
    *v = -radius; v++;
    *v = radius; v++;
    *v = -radius; v++;
    
    //2
    *v = -radius; v++;
    *v = radius; v++;
    *v = radius; v++;
    //1
    *v = radius; v++;
    *v = radius; v++;
    *v = radius; v++;

    //1
    *v = radius; v++;
    *v = radius; v++;
    *v = radius; v++;

    //6
    *v = -radius; v++;
    *v = radius; v++;
    *v = -radius; v++;
    //5
    *v = radius; v++;
    *v = radius; v++;
    *v = -radius; v++;
    
    // Bottom
    //0
    *v = radius; v++;
    *v = -radius; v++;
    *v = radius; v++;
    //3
    *v = -radius; v++;
    *v = -radius; v++;
    *v = radius; v++;

    //7
    *v = -radius; v++;
    *v = -radius; v++;
    *v = -radius; v++;

    
    //0
    *v = radius; v++;
    *v = -radius; v++;
    *v = radius; v++;
    //7
    *v = -radius; v++;
    *v = -radius; v++;
    *v = -radius;

    //4
    *v = radius; v++;
    *v = -radius; v++;
    *v = -radius; v++;


    }



    void
    wireBox(GLfloat radius, GLuint attr_pos ) 
    {
        //GLfloat* v = (GLfloat*)malloc(36*3*sizeof *v);
        GLfloat v[200];
        PlotBoxPoints(radius, v);
		glEnableVertexAttribArray(attr_pos);

        glVertexAttribPointer( attr_pos, 3, GL_FLOAT, GL_FALSE, 0, v );

        
        for ( GLint j = 0; j <= 7; ++j)
        {
            printf("j vale = %d\n", j);
                glDrawArrays(GL_LINE_STRIP, (j)*3, 3);
        }
    
        glDisableVertexAttribArray(attr_pos);
    
        //free( v );
        
        
        //glDrawElements(GL_TRIANGLES, 8, GL_UNSIGNED_SHORT, Indices);
    }


	void
	solidSphere(GLfloat radius, GLint slices, GLint stacks, GLuint attr_pos ) 
	{
		//GLfloat* v = (GLfloat*)malloc(stacks*(slices+1)*2*3*sizeof *v);
		//GLfloat* n = (GLfloat*)malloc(stacks*(slices+1)*2*3*sizeof *n);
		PlotSpherePoints(radius, stacks, slices, v, n);

		glVertexAttribPointer( attr_pos, 3, GL_FLOAT, GL_FALSE, 0, v );
		glEnableVertexAttribArray(attr_pos);
		GLint triangles = (slices + 1) * 2;
        printf("Llego a glDrawArrays\n");
        

		//for( GLint i = 0; i < stacks; i++)
			glDrawArrays(GL_TRIANGLE_STRIP, 0, triangles * stacks);
        printf("Paso a glDrawArrays\n");

		glDisableVertexAttribArray(attr_pos);

		//free( v );
		//free( n );
	}

	void
	wireSphere(GLfloat radius, GLint slices, GLint stacks, GLuint attr_pos ) 
	{
		//GLfloat* v = (GLfloat*)malloc(stacks*(slices+1)*2*3*sizeof *v);
		//GLfloat* n = (GLfloat*)malloc(stacks*(slices+1)*2*3*sizeof *n);
		PlotSpherePoints(radius, stacks, slices, v, n);

		glVertexAttribPointer( attr_pos, 3, GL_FLOAT, GL_FALSE, 0, v );
		glEnableVertexAttribArray(attr_pos);
		//for( GLint i = 0; i < stacks; ++i)

		//{
		//	GLint f = i * (slices + 1);
		//	for ( GLint j = 0; j <= slices; ++j)
        //      glDrawArrays(GL_LINE_LOOP, (f + j)*2, 3);
		//}
		glDrawArrays(GL_LINE_LOOP, 0, (slices + 1) * 2* stacks);

		glDisableVertexAttribArray(attr_pos);

		//free( v );
		//free( n );
	}

	string read_file( string filename )
	{
		ifstream file( filename.c_str(), ios::in );
		string line;
		ostringstream content;
		while( file.good() )
		{
			getline( file, line );
			content << line << "\n";
		}
		return content.str();
	}

	void printShaderInfoLog( GLuint obj )
	{
		int infologLength = 0;
		int charsWritten  = 0;
		char *infoLog;

		glGetShaderiv( obj, GL_INFO_LOG_LENGTH, &infologLength );

		if( infologLength > 0 )
		{
			infoLog = ( char * ) malloc( infologLength );
			glGetShaderInfoLog( obj, infologLength, &charsWritten, infoLog );
			printf( "%s\n", infoLog );
			free( infoLog );
		}
	}

	void printProgramInfoLog( GLuint obj )
	{
		int infologLength = 0;
		int charsWritten  = 0;
		char *infoLog;

		glGetProgramiv( obj, GL_INFO_LOG_LENGTH, &infologLength );

		if( infologLength > 0 )
		{
			infoLog = ( char * ) malloc( infologLength );
			glGetProgramInfoLog( obj, infologLength, &charsWritten, infoLog );
			printf( "%s\n",infoLog );
			free( infoLog );
		}
	}
