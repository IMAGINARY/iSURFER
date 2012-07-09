#include "programData.hpp"
#include "matrix.h"
#include "Vector.hpp"
#include "error.hpp"
#include "Matrix.hpp"

float programData::rotationX = 0.0f;
float programData::rotationY = 0.0f;
float programData::rotationZ = M_PI_2;
//float programData::Shininess = 0.20f;
float programData::Shininess = 2;
float programData::colorR = 0.5f;
float programData::colorG = 0.4f;
float programData::colorB = 0.8f;
float programData::colorR2 = 0.9f;
float programData::colorG2 = 0.5f;
float programData::colorB2 = 0.6f;
float programData::lposX = 5.0f;
float programData::lposY = 5.0f;
float programData::lposZ = 1.0f;
float programData::radius = 5;
vect4 origin;

mat4 programData::rot;

ProgramHandle programData::shaderHandle;
bool programData::debug = true;
bool programData::panoramic = false;

bool programData::box = false;
GLfloat programData::vertex[STACKS*(SLICES+1)*2*3];
GLfloat programData::normalized[STACKS*(SLICES+1)*2*3];
ProgramIdentifiers programData::programs;


void programData::InitializeProgramData()
{


    GLuint glsl_program = programData::programs.alg_surface_glsl_program;
    glUseProgram( glsl_program ); checkGLError( AT );
  
    programData::shaderHandle.u_modelview = glGetUniformLocation( glsl_program, "modelviewMatrix" ); checkGLError( AT );
    programData::shaderHandle.u_modelview_inv = glGetUniformLocation( glsl_program, "modelviewMatrixInverse" ); checkGLError( AT );
    programData::shaderHandle.u_projection = glGetUniformLocation( glsl_program, "projectionMatrix" ); checkGLError( AT );
    programData::shaderHandle.Radius2 = glGetUniformLocation(glsl_program, "radius2");
    programData::shaderHandle.eye = glGetUniformLocation(glsl_program, "varying_eye");
    programData::shaderHandle.LightPosition = glGetUniformLocation(glsl_program, "LightPosition");
    programData::shaderHandle.LightPosition2 = glGetUniformLocation(glsl_program, "LightPosition2");
    programData::shaderHandle.LightPosition3 = glGetUniformLocation(glsl_program, "LightPosition3");
    programData::shaderHandle.AmbientMaterial = glGetUniformLocation(glsl_program, "AmbientMaterial");
    programData::shaderHandle.AmbientMaterial2 = glGetUniformLocation(glsl_program, "AmbientMaterial2");
    programData::shaderHandle.SpecularMaterial = glGetUniformLocation(glsl_program, "SpecularMaterial");
    programData::shaderHandle.SpecularMaterial2 = glGetUniformLocation(glsl_program, "SpecularMaterial2");
    programData::shaderHandle.Shininess = glGetUniformLocation(glsl_program, "Shininess"); 
    programData::shaderHandle.DiffuseMaterial = glGetAttribLocation(glsl_program, "Diffuse");
    programData::shaderHandle.DiffuseMaterial2 = glGetAttribLocation(glsl_program, "Diffuse2");
    programData::shaderHandle.attr_pos = glGetAttribLocation( glsl_program, "pos" ); checkGLError( AT );
    glsl_program = programData::programs.wireframe_glsl_program;
    programData::shaderHandle.wire_attr_pos = glGetAttribLocation( glsl_program, "pos" ); checkGLError( AT );
    programData::shaderHandle.wire_modelview = glGetUniformLocation( glsl_program, "modelviewMatrix" ); checkGLError( AT );
    programData::shaderHandle.wire_projection = glGetUniformLocation( glsl_program, "projectionMatrix" ); checkGLError( AT );
    
    
    //glEnableVertexAttribArray(programData::shaderHandle.wire_attr_pos);	checkGLError( AT );
    //glEnableVertexAttribArray(programData::shaderHandle.attr_pos);	checkGLError( AT );
    
    
    
    //glGenBuffers(1, &programData::shaderHandle.wire_vertexBuffer);
    //glBindBuffer(GL_ARRAY_BUFFER, programData::shaderHandle.wire_vertexBuffer);
    //glBufferData(GL_ARRAY_BUFFER, STACKS*(SLICES+1)*2*3 *sizeof(*normalized), normalized, GL_STATIC_DRAW);

    
    
    
    
    //glGenBuffers(1, &programData::shaderHandle.vertexBuffer);	checkGLError( AT );
    //GLfloat* vertexPositions = sphereBuffer(5, SLICES , STACKS);	checkGLError( AT );
    //glBindBuffer(GL_ARRAY_BUFFER, programData::shaderHandle.vertexBuffer);	checkGLError( AT );
    //glBufferData(programData::shaderHandle.vertexBuffer, STACKS*(SLICES+1)*2*3 *sizeof(*normalized), normalized, GL_DYNAMIC_DRAW);	checkGLError( AT );
     
    
    
    programData::setConstant();
    programData::GenerateArrays();
}

void programData::setConstant()
{
    //Color ambient, sin luz
    UpdateColor(colorR, colorG, colorB);
    UpdateRadius(programData::radius);
    //Power de la luz
    glUniform1f(programData::shaderHandle.Shininess, programData::Shininess);
    //vec4 lightPosition(programData::radius, programData::radius, 0, 0);
    //glUniform3fv(programData::shaderHandle.LightPosition, 1, lightPosition.Pointer());
    vec4 lightPosition(0.25, 0.25, 1, 0);

    glUniform3fv(programData::shaderHandle.LightPosition, 1, lightPosition.Pointer());
    
    //vec4 lightPosition2(-1, 0, -200, 0);
    vec4 lightPosition2(-1, 0.5, 1, 0);

    glUniform3fv(programData::shaderHandle.LightPosition2, 1, lightPosition2.Pointer());

    vec4 lightPosition3(-programData::radius, -programData::radius, -programData::radius, 0);
    glUniform3fv(programData::shaderHandle.LightPosition3, 1, lightPosition3.Pointer());

    glUniform3f(programData::shaderHandle.DiffuseMaterial, programData::colorR, programData::colorG,programData::colorB);

}

void programData::SetEye(Matrix4x4 inverse){
    origin[0]=0.0;
    origin[1]=0.0;
    origin[2]=0.0;
    origin[3]=1.0;
    checkGLError( AT );
    
    mult_vect(inverse, origin, origin);
    glUniform3fv(programData::shaderHandle.eye, 1, origin);
    
    checkGLError( AT );
    
}



void programData::UpdateRadius(float Radius)
{
    programData::radius = Radius;
    glUniform1f(programData::shaderHandle.Radius2, programData::radius* programData::radius);
        
}

void programData::UpdateColor(float red, float green, float blue)
{
    programData::colorR =red;
    programData::colorG =green;
    programData::colorB =blue;
    
    //Color ambient, sin luz
    //float div = 4.0f;
//    float diffuseDiv = 0.75f;
    float diffuseDiv = 1;
    glUniform3f(programData::shaderHandle.DiffuseMaterial, programData::colorR *diffuseDiv, programData::colorG *diffuseDiv, programData::colorB *diffuseDiv);
    glUniform3f(programData::shaderHandle.DiffuseMaterial2, programData::colorR2 *diffuseDiv, programData::colorG2 *diffuseDiv, programData::colorB2 *diffuseDiv);
    /*
    glUniform3f(programData::shaderHandle.AmbientMaterial, programData::colorR / div, programData::colorG /div, programData::colorB / div);
    glUniform3f(programData::shaderHandle.AmbientMaterial2, programData::colorR2 / div, programData::colorG2 /div, programData::colorB2 / div);
    //R,G,B, alpha con luz
    glUniform3f(programData::shaderHandle.SpecularMaterial,  programData::colorR, programData::colorG, programData::colorB);
    glUniform3f(programData::shaderHandle.SpecularMaterial2, programData::colorR2, programData::colorG2, programData::colorB2);
  */
    glUniform3f(programData::shaderHandle.AmbientMaterial, 0.04f, 0.04f, 0.04f);
    glUniform3f(programData::shaderHandle.AmbientMaterial2,0.04f, 0.04f, 0.04f);
    //R,G,B, alpha con luz
    glUniform3f(programData::shaderHandle.SpecularMaterial,  programData::colorR, programData::colorG, programData::colorB);
    glUniform3f(programData::shaderHandle.SpecularMaterial2, programData::colorR2, programData::colorG2, programData::colorB2);

    //glUniform3f(programData::shaderHandle.SpecularMaterial,  1, 0.5, 0.5);
    //glUniform3f(programData::shaderHandle.SpecularMaterial2, 0.5, 0.5, 0.5);
    
    
}


void programData::GenerateArrays()
{
    // Initialize various state.
    glEnableVertexAttribArray(programData::shaderHandle.wire_attr_pos);	checkGLError( AT );
    glEnableVertexAttribArray(programData::shaderHandle.attr_pos);	checkGLError( AT );
    
    
    // no se
    glEnable(GL_DEPTH_TEST);

}






