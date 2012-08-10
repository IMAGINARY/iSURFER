#include "ParametricEquations.hpp"
#include "ParametricSurface.hpp"
#include "ApplicationEngineParametricViewer.hpp"

    
static const int SurfaceCount = 6;
    vector<ISurface*> surfaces(SurfaceCount);
    
    IApplicationEngine* CreateApplicationEngine(IRenderingEngine* renderingEngine)
    {
        return new ApplicationEngine(renderingEngine);
    }

    ApplicationEngine::ApplicationEngine(IRenderingEngine* renderingEngine) :
    currentSurface(0),
    m_renderingEngine(renderingEngine)
    {
    }
    
    ApplicationEngine::~ApplicationEngine()
    {
        delete m_renderingEngine;
    }

//TODO PICKER bounding box

    void ApplicationEngine::Initialize(int width, int height)
    {

        m_trackballRadius = width / 3;
        m_screenSize = ivec2(width, height);
        m_centerPoint = m_screenSize / 2;
        vector<ISurface*> surfaces2(SurfaceCount);
        surfaces2[0] = new Cone(5, 5);
        surfaces2[1] = new Sphere(5);
        surfaces2[2] = new Torus(1.4f, 0.3f);
        surfaces2[3] = new TrefoilKnot(1.8f);
        surfaces2[4] = new KleinBottle(0.2f);
        surfaces2[5] = new MobiusStrip(1);
        surfaces = surfaces2;
        m_renderingEngine->Initialize(surfaces);
        
    }
    

    void ApplicationEngine::Zoom(float radius){
        printf("zoom radius %f \n", radius);

        surfaces[currentSurface]->Zoom(radius);
        m_renderingEngine->UpdateSurface(surfaces, currentSurface);
    }

    void ApplicationEngine::ChangeSurface(int surfaceIndex){
        currentSurface = surfaceIndex;
        m_renderingEngine->UpdateSurface(surfaces, currentSurface);
        
    }
    
    void ApplicationEngine::Render(){
        m_renderingEngine->Render(currentSurface, m_orientation);
    }
    

    
    void ApplicationEngine::OnFingerDown(ivec2 location)
    {
        m_fingerStart = location;
        m_previousOrientation = m_orientation;
    }
    
    void ApplicationEngine::OnFingerMove(ivec2 oldLocation, ivec2 location)
    {
        vec3 start = MapToSphere(m_fingerStart);
        vec3 end = MapToSphere(location);
        Quaternion delta = Quaternion::CreateFromVectors(start, end);
        m_orientation = delta.Rotated(m_previousOrientation);
        
    }
    
    vec3 ApplicationEngine::MapToSphere(ivec2 touchpoint) const
    {
        vec2 p = touchpoint - m_centerPoint;
        
        // Flip the Y axis because pixel coords increase towards the bottom.
        p.y = -p.y;
        
        const float radius = m_trackballRadius;
        const float safeRadius = radius - 1;
        
        if (p.Length() > safeRadius) {
            float theta = atan2(p.y, p.x);
            p.x = safeRadius * cos(theta);
            p.y = safeRadius * sin(theta);
        }
        
        float z = sqrt(radius * radius - p.LengthSquared());
        vec3 mapped = vec3(p.x, p.y, z);
        return mapped / radius;
    }






