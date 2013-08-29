#pragma once
#ifndef interfaces_h
#define interfaces_h

#import <OpenGLES/ES2/gl.h>



/**
 * This module is written in C++. it is in charge
 of parsing initialize and generate some Data to use OpenGL.
 
 Some parts are based on the book "iPhone 3D programming" from O'Reilly.
 by dazar

 * Version: 1.0
 * @module Engine
 */

/** 
 * Last modified on February 13 2012 by dazar
 * -----------------------------------------------------
 * This interface provides access to a Matrix library. Matrix2, Matrix3, Matrix4.
 * It is based on the book "iPhone 3D Programming" with some added functionality like matrix inverse.
 * 
 * @class ApplicationEngine
 */



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
    /**
     * Usage: Initialize(w, h);
     * ----------------------------------
     * Initialize the engine. Creates the default parmetric surfaces. 
     * @method Initialize
     * @param width {int} pixels width.
     * @param height {int} pixels height.
     */
    virtual void Initialize(int width, int height) = 0;
    /**
     * Usage: OnFingerDown(l);
     * ----------------------------------
     * Starts a gesture, rotation. 
     * @method OnFingerDown
     * @param location {ivec2} locaiton press.
     */
    virtual void OnFingerDown(ivec2 location) = 0;
    /**
     * Usage: OnFingerDown(ld, ln);
     * ----------------------------------
     * continue a gesture, rotation. 
     * @method OnFingerDown
     * @param oldlocation {ivec2} old locaiton press.
     * @param newlocation {ivec2} new locaiton press.
     */
    virtual void OnFingerMove(ivec2 oldLocation, ivec2 newLocation) = 0;
    /**
     * Usage: Zoom(z);
     * ----------------------------------
     * Sets a new zoom radius. 
     * @method Zoom
     * @param radius {float} radius too set zoom.
     */
    virtual void Zoom(float radius) = 0;
    /**
     * Usage: Render();
     * ----------------------------------
     * renders one frame. 
     * @method Render
     @return void;
     */
    virtual void Render() = 0;
    
    /**
     * Usage: ChangeSurface(3);
     * ----------------------------------
     * Sets a new parametric surface. 
     * @method Initialize
     * @param surfaceIndex {int} new surface index.
     */
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
    virtual ~IRenderingEngine() {}
};

struct IResourceManager {
    virtual string GetResourcePath() const = 0;
    virtual void LoadPngImage(const string& filename) = 0;
    virtual void* GetImageData() = 0;
    virtual ivec2 GetImageSize() = 0;
    virtual void UnloadImage() = 0;
    virtual ~IResourceManager() {}
};


namespace ParametricViewer { IApplicationEngine* CreateApplicationEngine(IRenderingEngine*); }
namespace WireframeES2 { IRenderingEngine* CreateRenderingEngine(); }
namespace SolidES2     { IRenderingEngine* CreateRenderingEngine(); }
namespace SolidGL2     { IRenderingEngine* CreateRenderingEngine(); }
namespace FacetedES2   { IRenderingEngine* CreateRenderingEngine(); }
namespace DepthViewer  { IRenderingEngine* CreateRenderingEngine(); }
namespace Darwin       { IResourceManager* CreateResourceManager(); }

namespace ParametricViewer {   
class ApplicationEngine : public IApplicationEngine {
public:
    ApplicationEngine(IRenderingEngine* renderingEngine);
    ~ApplicationEngine();
    void Initialize(int width, int height);
    void OnFingerDown(ivec2 location);
    void OnFingerMove(ivec2 oldLocation, ivec2 newLocation);
    void Zoom(float radius);
    void Render();
    void ChangeSurface(int surfaceIndex);
private:
    vec3 MapToSphere(ivec2 touchpoint) const;
    float m_trackballRadius;
    Quaternion m_orientation;
    Quaternion m_previousOrientation;
    ivec2 m_fingerStart;
    ivec2 m_screenSize;
    ivec2 m_centerPoint;
    IRenderingEngine* m_renderingEngine;
    vector<ISurface*> surfaces;
    int currentSurface;
    
};
}
#endif
