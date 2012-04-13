#pragma once
#ifndef interfaces_h
#define interfaces_h

#import <OpenGLES/ES2/gl.h>


#include "Quaternion.hpp"
#include <vector>
#include <string>

using std::vector;
using std::string;

enum VertexFlags {
    VertexFlagsNormals = 1 << 0,
    VertexFlagsTexCoords = 1 << 1,
};

struct IApplicationEngine {
    virtual void Initialize(int width, int height) = 0;
    virtual void OnFingerDown(ivec2 location) = 0;
    virtual void OnFingerMove(ivec2 oldLocation, ivec2 newLocation) = 0;
    virtual void Zoom(float radius) = 0;
    virtual void Render() = 0;
    virtual void ChangeSurface(int surfaceIndex) = 0;
    virtual ~IApplicationEngine() {}


};

struct ISurface {
    virtual int GetVertexCount() const = 0;
    virtual int GetLineIndexCount() const = 0;
    virtual int GetTriangleIndexCount() const = 0;
    virtual void GenerateVertices(vector<float>& vertices,
                                  unsigned char flags = 0) const = 0;
    virtual void GenerateLineIndices(vector<unsigned short>& indices) const = 0;
    virtual void GenerateTriangleIndices(vector<unsigned short>& indices) const = 0;
    virtual void Zoom(const float newRadius)  = 0;

    virtual ~ISurface() {}
};

struct Visual {
    vec3 Color;
    ivec2 LowerLeft;
    ivec2 ViewportSize;
    Quaternion Orientation;
};

struct Drawable {
    GLuint VertexBuffer;
    GLuint IndexBuffer;
    int IndexCount;
};


struct IRenderingEngine {
    virtual void Initialize(vector<ISurface*>& surfaces) = 0;
    virtual void UpdateSurface(vector<ISurface*>& surfaces, int currentSurface) = 0;
    virtual void Render(int currentSurface, Quaternion orientation) = 0;
};


namespace ParametricViewer { IApplicationEngine* CreateApplicationEngine(IRenderingEngine*); }
namespace WireframeES2 { IRenderingEngine* CreateRenderingEngine(); }
namespace SolidES2     { IRenderingEngine* CreateRenderingEngine(); }
namespace SolidGL2     { IRenderingEngine* CreateRenderingEngine(); }
namespace FacetedES2   { IRenderingEngine* CreateRenderingEngine(); }
namespace DepthViewer  { IRenderingEngine* CreateRenderingEngine(); }


#endif
