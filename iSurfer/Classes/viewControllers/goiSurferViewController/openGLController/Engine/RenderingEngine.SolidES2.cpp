#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include "Interfaces.hpp"
#include "surfaceRender.h"

#include <iostream>

namespace SolidES2 {

    

class RenderingEngine : public IRenderingEngine {
public:
    RenderingEngine();
    void Initialize(vector<ISurface*>& surfaces);
    void UpdateSurface(vector<ISurface*>& surfaces, int currentSurface);
    void Render(int currentSurface, Quaternion orientation);
    vector<Drawable> m_drawables;
private:
    GLuint BuildShader(const char* source, GLenum shaderType) const;
    GLuint BuildProgram(const char* vShader, const char* fShader) const;
    GLuint m_colorRenderbuffer;
    GLuint m_depthRenderbuffer;
};


IRenderingEngine* CreateRenderingEngine()
{
    return new RenderingEngine();
}

RenderingEngine::RenderingEngine()
{
    glGenRenderbuffers(1, &m_colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, m_colorRenderbuffer);
}

void RenderingEngine::Initialize(vector<ISurface*>& surfaces)
{
    vector<ISurface*>::const_iterator surface;
    for (surface = surfaces.begin(); surface != surfaces.end(); ++surface) {
        
        // Create the VBO for the vertices.
        vector<float> vertices;
        (*surface)->GenerateVertices(vertices, VertexFlagsNormals);
        GLuint vertexBuffer;
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER,
                     vertices.size() * sizeof(vertices[0]),
                     &vertices[0],
                     GL_DYNAMIC_DRAW);
        
        // Create a new VBO for the indices if needed.
        int indexCount = (*surface)->GetTriangleIndexCount();
        GLuint indexBuffer;
        if (!m_drawables.empty() && indexCount == m_drawables[0].IndexCount) {
            indexBuffer = m_drawables[0].IndexBuffer;
        } else {
            vector<GLushort> indices(indexCount);
            (*surface)->GenerateTriangleIndices(indices);
            glGenBuffers(1, &indexBuffer);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
            glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                         indexCount * sizeof(GLushort),
                         &indices[0],
                         GL_STATIC_DRAW);
        }
        
        Drawable drawable = { vertexBuffer, indexBuffer, indexCount};
        m_drawables.push_back(drawable);
    }
    
}
    
void RenderingEngine::UpdateSurface(vector<ISurface*>& surfaces, int currentSurface)
{
    ISurface * surface = surfaces[currentSurface];
    //vector<ISurface*>::const_iterator surface;
    // Create the VBO for the vertices. 
    vector<float> vertices;
    (surface)->GenerateVertices(vertices, VertexFlagsNormals);
    GLuint vertexBuffer = m_drawables[currentSurface].VertexBuffer;
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER,
                 vertices.size() * sizeof(vertices[0]),
                 &vertices[0],
                 GL_DYNAMIC_DRAW);
/*
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER,
                 vertices.size() * sizeof(vertices[0]),
                 &vertices[0],
                 GL_DYNAMIC_DRAW);
*/
//    glBufferSubData(GL_ARRAY_BUFFER, 0, 
//                    vertices.size() * sizeof(vertices[0]),
//                    &vertices[0]);    
}

    
    void RenderingEngine::Render(int currentSurface, Quaternion orientation) 
    {
        Drawable drawable = m_drawables[currentSurface];
        //surfaceRender::hola();
        surfaceRender::display(drawable, orientation);

    }
    
    
    
    
}
