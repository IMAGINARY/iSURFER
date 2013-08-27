#include "programData.hpp"
#include "Vector.hpp"
#include "error.hpp"
#include "Matrix.hpp"
#include "Interfaces.hpp"
float programData::rotationX = 0.0f;
float programData::rotationY = 0.0f;
float programData::rotationZ = M_PI_2;
//float programData::Shininess = 0.20f;
float programData::Shininess = 50;
float programData::colorR = 0.5f;
float programData::colorG = 0.4f;
float programData::colorB = 0.8f;
float programData::colorR2 = 0.9f;
float programData::colorG2 = 0.5f;
float programData::colorB2 = 0.6f;
float programData::lposX = 0.25f;
float programData::lposY = 0.25f;
float programData::lposZ = 1.0f;
float programData::radius = 5;
float origin[5];
char * programData::textureFileName = "bricks";

mat4 programData::rot;

ProgramHandle programData::shaderHandle;
bool programData::wireFrame = false;
bool programData::panoramic = false;
bool programData::toonShader = false;
bool programData::textureEnable = false;
bool programData::backgroundBlack = false;

GLuint m_gridTexture;
IResourceManager *m_resourceManager;
ProgramIdentifiers programData::programs;


void programData::InitializeProgramData()
{
    m_resourceManager = Darwin::CreateResourceManager();


    GLuint glsl_program = programData::programs.alg_surface_glsl_program;
    glUseProgram( glsl_program ); checkGLError( AT );

    //printf("%d\n", glsl_program);
    programData::shaderHandle.u_modelview = glGetUniformLocation( glsl_program, "modelviewMatrix" ); checkGLError( AT );
    programData::shaderHandle.u_modelview_inv = glGetUniformLocation( glsl_program, "modelviewMatrixInverse" ); checkGLError( AT );
    programData::shaderHandle.u_projection = glGetUniformLocation( glsl_program, "projectionMatrix" ); checkGLError( AT );
    programData::shaderHandle.Radius2 = glGetUniformLocation(glsl_program, "radius2");
    programData::shaderHandle.eye = glGetUniformLocation(glsl_program, "origin");
    programData::shaderHandle.LightPosition = glGetUniformLocation(glsl_program, "LightPosition");
    programData::shaderHandle.LightPosition2 = glGetUniformLocation(glsl_program, "LightPosition2");
    programData::shaderHandle.LightPosition3 = glGetUniformLocation(glsl_program, "LightPosition3");
    programData::shaderHandle.AmbientMaterial = glGetUniformLocation(glsl_program, "AmbientMaterial");
    programData::shaderHandle.AmbientMaterial2 = glGetUniformLocation(glsl_program, "AmbientMaterial2");
    programData::shaderHandle.SpecularMaterial = glGetUniformLocation(glsl_program, "SpecularMaterial");
    programData::shaderHandle.SpecularMaterial2 = glGetUniformLocation(glsl_program, "SpecularMaterial2");
    programData::shaderHandle.DiffuseMaterial = glGetUniformLocation(glsl_program, "DiffuseMaterial");
    programData::shaderHandle.DiffuseMaterial2 = glGetUniformLocation(glsl_program, "DiffuseMaterial2");

    programData::shaderHandle.Shininess = glGetUniformLocation(glsl_program, "Shininess");
    programData::shaderHandle.CELLSHADE = glGetUniformLocation(glsl_program, "CELLSHADE");
    programData::shaderHandle.Sampler = glGetUniformLocation(glsl_program, "Sampler");
    programData::shaderHandle.TEXTURE = glGetUniformLocation(glsl_program, "TEXTURE");

    programData::shaderHandle.TextureCoord = glGetAttribLocation(glsl_program, "TextureCoord");
    programData::shaderHandle.attr_pos = glGetAttribLocation( glsl_program, "pos" ); checkGLError( AT );
    glsl_program = programData::programs.wireframe_glsl_program;
    programData::shaderHandle.wire_attr_pos = glGetAttribLocation( glsl_program, "pos" ); checkGLError( AT );
    programData::shaderHandle.wire_modelview = glGetUniformLocation( glsl_program, "modelviewMatrix" ); checkGLError( AT );
    programData::shaderHandle.wire_projection = glGetUniformLocation( glsl_program, "projectionMatrix" ); checkGLError( AT );
    setTexture(textureEnable);
    initializeTexture(textureFileName);
    programData::setConstant();
    programData::GenerateArrays();
    programData::setCellShade(toonShader);
    SetEye();
}

void programData::setCellShade(bool cellshading)
{
    float value = 1.0;
    if (cellshading) {
        value = 1.0;
    }else
    {
        value =0.0;
    }
    glUniform1f(programData::shaderHandle.CELLSHADE, value);
    
    
}

void programData::setTexture(bool texture)
{
  
    float value = 1.0;
    if (texture) {
        value = 1.0;
    }else
    {
        value =0.0;
    }
    glUniform1f(programData::shaderHandle.TEXTURE, value);
    
}

void programData::initializeTexture(char * filename)
{
    glDeleteTextures(1, &m_gridTexture);
    // Set the active sampler to stage 0.  Not really necessary since the uniform
    // defaults to zero anyway, but good practice.
    glActiveTexture(GL_TEXTURE0);checkGLError( AT );
    
    glUniform1i(programData::shaderHandle.Sampler, 0);   checkGLError( AT );
    
    
    // Load the texture.
    glGenTextures(1, &m_gridTexture);   checkGLError( AT );
    glBindTexture(GL_TEXTURE_2D, m_gridTexture);   checkGLError( AT );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);   checkGLError( AT );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);   checkGLError( AT );
    
    //m_resourceManager->LoadPngImage("Grid16");
    m_resourceManager->LoadPngImage(filename);   checkGLError( AT );
    void* pixels = m_resourceManager->GetImageData();   checkGLError( AT );
    ivec2 size = m_resourceManager->GetImageSize();   checkGLError( AT );
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size.x, size.y, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);   checkGLError( AT );
    m_resourceManager->UnloadImage();   checkGLError( AT );
    glGenerateMipmap(GL_TEXTURE_2D);   checkGLError( AT );
    
}


void programData::setConstant()
{
    //Color ambient, sin luz
    UpdateColor();
    UpdateRadius(programData::radius);
    //Power de la luz
    glUniform1f(programData::shaderHandle.Shininess, programData::Shininess);

    vec4 lightPosition(0.25, 0.25, 1, 0);

    glUniform3fv(programData::shaderHandle.LightPosition, 1, lightPosition.Pointer());
    
    vec4 lightPosition2(-0.25, -0.25, -1, 0);

    glUniform3fv(programData::shaderHandle.LightPosition2, 1, lightPosition2.Pointer());

    vec4 lightPosition3(-programData::radius, -programData::radius, -programData::radius, 0);
    glUniform3fv(programData::shaderHandle.LightPosition3, 1, lightPosition3.Pointer());


}

void programData::SetEye(/*Matrix4x4 inverse*/){
    origin[0]=0.0;
    origin[1]=0.0;
    origin[2]=0.0;
    origin[3]=1.0;
    origin[4]=1.0;
    checkGLError( AT );
    
    //mult_vect(inverse, origin, origin);
    glUniform4fv(programData::shaderHandle.eye, 1, origin);
    
    checkGLError( AT );
    
}



void programData::UpdateRadius(float Radius)
{
    programData::radius = Radius;
    glUniform1f(programData::shaderHandle.Radius2, programData::radius* programData::radius);
        
}

void programData::UpdateColor()
{
    
    float diffuseDiv = 0.8f;
    glUniform3f(programData::shaderHandle.DiffuseMaterial, programData::colorR*diffuseDiv , programData::colorG*diffuseDiv, programData::colorB*diffuseDiv );
    glUniform3f(programData::shaderHandle.DiffuseMaterial2, programData::colorR2 *diffuseDiv, programData::colorG2 *diffuseDiv, programData::colorB2 *diffuseDiv);
    float ambientDiv = 0.4f;
    
    glUniform3f(programData::shaderHandle.AmbientMaterial, programData::colorR *ambientDiv, programData::colorG *ambientDiv, programData::colorB *ambientDiv);
    glUniform3f(programData::shaderHandle.AmbientMaterial2,programData::colorR2 *ambientDiv, programData::colorG2 *ambientDiv, programData::colorB2 *ambientDiv);
    //R,G,B, alpha con luz

    float specularDiv = 0.8f;
    glUniform3f(programData::shaderHandle.SpecularMaterial ,  programData::colorR * specularDiv, programData::colorG * specularDiv, programData::colorB * specularDiv);
    glUniform3f(programData::shaderHandle.SpecularMaterial2, programData::colorR2 * specularDiv, programData::colorG2 * specularDiv, programData::colorB2 * specularDiv);
    
    
}



void programData::UpdateColor(float red, float green, float blue)
{
    programData::colorR =red;
    programData::colorG =green;
    programData::colorB =blue;
    
    
    UpdateColor();
    
}

void programData::UpdateColor2(float red, float green, float blue)
{
    programData::colorR2 =red;
    programData::colorG2 =green;
    programData::colorB2 =blue;
    
    UpdateColor();
    
}


void programData::GenerateArrays()
{
    // Initialize various state.
    glEnableVertexAttribArray(programData::shaderHandle.wire_attr_pos);	checkGLError( AT );
    glEnableVertexAttribArray(programData::shaderHandle.attr_pos);	checkGLError( AT );
    glEnableVertexAttribArray(programData::shaderHandle.TextureCoord); checkGLError( AT );

    
    // no se
    glEnable(GL_DEPTH_TEST);

}






