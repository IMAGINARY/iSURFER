#include "iSurferDelegate.h"
#include "matrix.h"

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
extern "C" {
#include <stdio.h>
#include "genlib.h"
#include "strlib.h"
#include "simpio.h"
#include "exp.h"
#include "scanadt.h"
#include "parser.h"
}
float iSurferDelegate::rotationX = 0.0f;
float iSurferDelegate::rotationY = 0.0f;
float iSurferDelegate::rotationZ = 0.0f;
GLuint iSurferDelegate::alg_surface_glsl_program = 0u;
GLuint iSurferDelegate::wireframe_glsl_program = 0u;

using namespace std;

void solidSphere( GLfloat radius, GLint slices, GLint stacks, GLuint attr_pos );
void wireSphere( GLfloat radius, GLint slices, GLint stacks, GLuint attr_pos );
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
    expressionT exp;
    scanner= NewScanner();
    SetScannerSpaceOption(scanner, IgnoreSpaces);
	
	SetScannerString(scanner, (char *)formula);
	exp= ParseExp(scanner);
	clearExp();
	EvalExp(exp);
	printf(getCode());
//	printf("\n");
//	printf("Degree %d \n", EvalDegree(exp));
	
	alg_surface_glsl_program = init( vs1/*"vs1.glsl"*/, fs1/*"fs1.glsl"*/ );
	//wireframe_glsl_program = init( vs2/*"vs2.glsl"*/, fs2/*"fs2.glsl"*/ );

	checkGLError( AT );
	set_light_and_material();
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
	
	char * shader_code_c_str = (char *) malloc( shaderLen + codeLen + 1) ;
	int position = 7 + FindString((char *) "return ", (char * )fragment_shader_code_c_str, 1);
	memcpy(shader_code_c_str , fragment_shader_code_c_str, position);
	memcpy(shader_code_c_str + position, getCode(), codeLen);
	memcpy(shader_code_c_str + position + codeLen, fragment_shader_code_c_str + position + 1, shaderLen - position );
	shader_code_c_str[codeLen + shaderLen + 1] = '\0';
	printf("\n\n\n\n\n%s\n\n\n\n\n\n\n", shader_code_c_str);
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
	printf( "\n" );

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

	// setup matrices
	Matrix4x4 t, s, rx, ry, rz, modelview, modelview_inv;
	
	//Para el zoom parametrizar scale_matrix
	//Para rotacion setear las variables de rotation_matrix
	//Traslacion si es necesario usar la matriz
	scale_matrix( 3.55f, 3.55f, 3.55f, s );
	translation_matrix( 0.0, 0.0, -7.5, t );
	rotation_matrix( 1.0f, 0.0f, 0.0f, iSurferDelegate::rotationX, rx );
	rotation_matrix( 0.0f, 1.0f, 0.0f, iSurferDelegate::rotationY, ry );
	rotation_matrix( 0.0f, 0.0f, 1.0f, iSurferDelegate::rotationZ, rz );
	mult_matrix( t, s, modelview );
	mult_matrix( modelview, rx, modelview );
	mult_matrix( modelview, ry, modelview );
	mult_matrix( modelview, rz, modelview );
	
	invert_matrix( modelview, modelview_inv );

	Matrix4x4 projection;
	perspective_projection_matrix( 60.0, 1.0, 3.0, 12.0, projection );

	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT ); checkGLError( AT );
	glClearColor( 1.0, 1.0, 1.0, 1.0 );

	// enable blending
	glEnable (GL_BLEND);
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

	// set culling properties
	glFrontFace( GL_CCW );
	glCullFace( GL_BACK );
/*
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

		wireSphere( 1.0, 20, 20, attr_pos ); checkGLError( AT );
	}
*/	// draw solid sphere, which is used for raycasting
	{
		glEnable( GL_CULL_FACE );

		GLuint glsl_program = alg_surface_glsl_program;
		glUseProgram( glsl_program ); checkGLError( AT );

		GLint attr_pos = glGetAttribLocation( glsl_program, "pos" ); checkGLError( AT );

		GLint u_modelview = glGetUniformLocation( glsl_program, "modelviewMatrix" ); checkGLError( AT );
		GLint u_modelview_inv = glGetUniformLocation( glsl_program, "modelviewMatrixInverse" ); checkGLError( AT );
		GLint u_projection = glGetUniformLocation( glsl_program, "projectionMatrix" ); checkGLError( AT );

		glUniformMatrix4fv( u_modelview, 1, GL_FALSE, modelview ); checkGLError( AT );
		glUniformMatrix4fv( u_modelview_inv, 1, GL_FALSE, modelview_inv ); checkGLError( AT );
		glUniformMatrix4fv( u_projection, 1, GL_FALSE, projection ); checkGLError( AT );

		solidSphere( 1.0, 20, 20, attr_pos ); checkGLError( AT );
	}
	checkGLError( AT );
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

void iSurferDelegate::set_light_and_material()
{
/*
	// Brass
	GLfloat front_emission_color[ 4 ] = { 0.0f, 0.0f, 0.0f, 1.0f };
	GLfloat front_ambient_color[ 4 ]  = { 0.329412f, 0.223529f, 0.027451f, 1.0f };
	GLfloat front_diffuse_color[ 4 ]  = { 0.780392f, 0.568627f, 0.113725f, 1.0f };
	GLfloat front_specular_color[ 4 ] = { 0.992157f, 0.941176f, 0.807843f, 1.0f };
	GLfloat front_shininess = 0.21794872f * 128.0f;

	glMaterialfv( GL_FRONT, GL_EMISSION, front_emission_color );
	glMaterialfv( GL_FRONT, GL_AMBIENT, front_ambient_color );
	glMaterialfv( GL_FRONT, GL_DIFFUSE, front_diffuse_color );
	glMaterialfv( GL_FRONT, GL_SPECULAR, front_specular_color );
	glMaterialf( GL_FRONT, GL_SHININESS, front_shininess );

	// Ruby
	GLfloat back_emission_color[ 4 ] = { 0.0f, 0.0f, 0.0f, 1.0f };
	GLfloat back_ambient_color[ 4 ]  = { 0.1745f, 0.01175f, 0.01175f, 1.0f };
	GLfloat back_diffuse_color[ 4 ]  = { 0.61424f, 0.04136f, 0.04136f, 1.0f };
	GLfloat back_specular_color[ 4 ] = {0.727811f, 0.626959f, 0.626959f, 1.0f };
	GLfloat back_shininess = 0.6f * 128.0f;

	glMaterialfv( GL_BACK, GL_EMISSION, back_emission_color );
	glMaterialfv( GL_BACK, GL_AMBIENT, back_ambient_color );
	glMaterialfv( GL_BACK, GL_DIFFUSE, back_diffuse_color );
	glMaterialfv( GL_BACK, GL_SPECULAR, back_specular_color );
	glMaterialf( GL_BACK, GL_SHININESS, back_shininess );

	GLfloat gl_light0_position[ 4 ] = { 1.0f, 1.0f, 1.0f, 1.0f };

	GLfloat gl_light0_ambient[ 4 ]  = { 1.0f, 1.0f, 1.0f, 1.0f };
	GLfloat gl_light0_diffuse[ 4 ]  = { 1.0f, 1.0f, 1.0f, 1.0f };
	GLfloat gl_light0_specular[ 4 ] = { 1.0f, 1.0f, 1.0f, 1.0f };

	GLfloat gl_light0_constant_attenuation = 1.0f;
	GLfloat gl_light0_linear_attenuation = 0.001f;
	GLfloat gl_light0_quadratic_attenuation = 0.004f;

	GLfloat gl_light0_spot_direection[ 3 ] = { -1.0f, -1.0f, -6.0f };
	GLfloat gl_light0_spot_cutoff = 180.0f;
	GLfloat gl_light0_spot_exponent = 100.0f;

	glLightfv( GL_LIGHT0, GL_POSITION, gl_light0_position );

	glLightfv( GL_LIGHT0, GL_AMBIENT, gl_light0_ambient );
	glLightfv( GL_LIGHT0, GL_DIFFUSE, gl_light0_diffuse );
	glLightfv( GL_LIGHT0, GL_SPECULAR, gl_light0_specular );

	glLightf( GL_LIGHT0, GL_CONSTANT_ATTENUATION, gl_light0_constant_attenuation );
	glLightf( GL_LIGHT0, GL_LINEAR_ATTENUATION, gl_light0_linear_attenuation );
	glLightf( GL_LIGHT0, GL_QUADRATIC_ATTENUATION, gl_light0_quadratic_attenuation );

    glLightfv( GL_LIGHT0, GL_SPOT_DIRECTION, gl_light0_spot_direection );
    glLightf( GL_LIGHT0, GL_SPOT_CUTOFF, gl_light0_spot_cutoff );
    glLightf( GL_LIGHT0, GL_SPOT_EXPONENT, gl_light0_spot_exponent );

	// disable other lights
	GLfloat gl_lights_ambient[ 4 ]  = { 1.0f, 1.0f, 1.0f, 0.0f };
	glLightfv( GL_LIGHT1, GL_AMBIENT, gl_lights_ambient );
	glLightfv( GL_LIGHT2, GL_AMBIENT, gl_lights_ambient );
	glLightfv( GL_LIGHT3, GL_AMBIENT, gl_lights_ambient );
	glLightfv( GL_LIGHT4, GL_AMBIENT, gl_lights_ambient );
	glLightfv( GL_LIGHT5, GL_AMBIENT, gl_lights_ambient );
	glLightfv( GL_LIGHT6, GL_AMBIENT, gl_lights_ambient );
	glLightfv( GL_LIGHT7, GL_AMBIENT, gl_lights_ambient );
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


	void
	solidSphere(GLfloat radius, GLint slices, GLint stacks, GLuint attr_pos ) 
	{
		GLfloat* v = (GLfloat*)malloc(stacks*(slices+1)*2*3*sizeof *v);
		GLfloat* n = (GLfloat*)malloc(stacks*(slices+1)*2*3*sizeof *n);
		PlotSpherePoints(radius, stacks, slices, v, n);

		glVertexAttribPointer( attr_pos, 3, GL_FLOAT, GL_FALSE, 0, v );
		glEnableVertexAttribArray(attr_pos);
		GLint triangles = (slices + 1) * 2;
		for( GLint i = 0; i < stacks; i++)
			glDrawArrays(GL_TRIANGLE_STRIP, i * triangles, triangles);

		glDisableVertexAttribArray(attr_pos);

		free( v );
		free( n );
	}

	void
	wireSphere(GLfloat radius, GLint slices, GLint stacks, GLuint attr_pos ) 
	{
		GLfloat* v = (GLfloat*)malloc(stacks*(slices+1)*2*3*sizeof *v);
		GLfloat* n = (GLfloat*)malloc(stacks*(slices+1)*2*3*sizeof *n);
		PlotSpherePoints(radius, stacks, slices, v, n);

		glVertexAttribPointer( attr_pos, 3, GL_FLOAT, GL_FALSE, 0, v );
		glEnableVertexAttribArray(attr_pos);
		for( GLint i = 0; i < stacks; ++i)

		{
			GLint f = i * (slices + 1);
			for ( GLint j = 0; j <= slices; ++j)
				glDrawArrays(GL_LINE_LOOP, (f + j)*2, 3);
		}

		glDisableVertexAttribArray(attr_pos);

		free( v );
		free( n );
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
