
#include "Compiler.hpp"
#include "error.hpp"
#include "programData.hpp"

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


expressionT expt;
using namespace std;




string read_file( string filename );
void printShaderInfoLog( GLuint obj );
void printProgramInfoLog( GLuint obj );
bool Compiler::compileWireframe=true;
bool Compiler::compileVertex=true;
GLuint vertex_shader;


void Compiler::init(const char *vs1, const char *fs1, const char *vs2, const char *fs2, const char *formula)
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
    FreeTree(expt);
    glDeleteShader(programData::programs.alg_surface_glsl_program);
    printf("code\n");
	printf("%s", getCode());
    printf("\nformula\n");
	printf("%s",formula);
    
    printf("\nderivate\n");
    printf("%s", getCodeDerivate());
    printf("\nderivate\n");
    
    //To print degre uncomment next line
	//printf("\nDegree %d \n", EvalDegree(exp));

    //To get OpenGL range and precision uncomment next three lines
    //int range, precision;
    //glGetShaderPrecisionFormat(GL_FRAGMENT_SHADER, GL_HIGH_FLOAT, &range, &precision);
    //printf("Range %d, precision %d.\n", range, precision);
    
    
	checkGLError( AT );
    
    if(compileWireframe){
        compileWireframe = false;
        glDeleteShader(programData::programs.wireframe_glsl_program);
        programData::programs.wireframe_glsl_program = initWire( vs2/*"vs2.glsl"*/, fs2/*"fs2.glsl"*/ );
    }
	checkGLError( AT );

    
	GLuint aux = init( vs1, fs1 );
    programData::programs.alg_surface_glsl_program = aux;
	checkGLError( AT );
    
    
}

GLuint Compiler::init( const char* vertex_shader_name, const char* fragment_shader_name )
{
	GLint error_code;
    if(compileVertex)
    {
        compileVertex = false;
        // create, load and compile vertex shader
        vertex_shader = glCreateShader( GL_VERTEX_SHADER );
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
                return 2134235643;
            }
            else
            {
                printShaderInfoLog( vertex_shader );
                printf( "Vertex Shader \"%s\" successfully compiled. %u \n", vertex_shader_name, vertex_shader );
            }
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

    //Uncoment next line too print complete shader code.
	//printf("\n\n\n\n\n%s\n\n\n\n\n\n\n", shader_code_c_str);
	//fflush(stdout);

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
			return 2134235643;
		}
		else
		{
			printf( "Fragment Shader \"%s\" successfully compiled. %u \n", fragment_shader_name, fragment_shader );
		}
	}
	
	GLuint glsl_program = glCreateProgram();
	glAttachShader( glsl_program, vertex_shader );
	glAttachShader( glsl_program, fragment_shader );
	glLinkProgram( glsl_program );
    glDeleteProgram( fragment_shader);
	{
		glGetProgramiv( glsl_program, GL_LINK_STATUS, &error_code );
		if( error_code == GL_FALSE )
		{
			printf( "Error during GLSL program %i linking.\n", glsl_program );
			printProgramInfoLog( glsl_program );
			return 2134235643;
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
			return 2134235643;
		}
	}

	glUseProgram( glsl_program );
	return glsl_program;
}


GLuint Compiler::initWire( const char* vertex_shader_name, const char* fragment_shader_name )
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
			printf( "Vertex Shader \"%s\" successfully compiled. %u \n", vertex_shader_name, vertex_shader );

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
            printf( "%u successfully linked.\n", fragment_shader );

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
    
    glDeleteProgram(vertex_shader);
    glDeleteProgram(fragment_shader);
	glUseProgram( glsl_program );
    
	return glsl_program;
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
