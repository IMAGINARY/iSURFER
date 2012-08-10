//
//  ApplicationEngineParametricViewer.h
//  iSurfer
//
//  Created by Damian Modernell on 8/10/12.
//
//

#ifndef iSurfer_ApplicationEngineParametricViewer_h
#define iSurfer_ApplicationEngineParametricViewer_h
#include "Interfaces.hpp"


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


#endif
