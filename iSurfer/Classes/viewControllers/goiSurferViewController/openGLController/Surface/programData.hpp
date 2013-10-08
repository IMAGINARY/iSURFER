#ifndef __PROGRAMDATA_H__
#define __PROGRAMDATA_H__


#import <OpenGLES/ES2/gl.h>
#import "Vector.hpp"
#include "Matrix.hpp"

#define STACKS 10
#define SLICES 10

struct ProgramHandle {
    GLuint attr_pos;
    GLint u_modelview;
    GLint u_modelview_inv;
    GLint u_projection;
    GLuint LightPosition;
    GLuint eye;
    GLuint LightPosition2;
    GLuint LightPosition3;
    GLint AmbientMaterial;
    GLint AmbientMaterial2;
    GLint SpecularMaterial;
    GLint SpecularMaterial2;
    GLint Shininess;
    GLint CELLSHADE;
    GLint DiffuseMaterial;
    GLint DiffuseMaterial2;
    GLint Radius2;
    GLint wire_attr_pos;
    GLint wire_modelview;
    GLint wire_projection;
    GLuint vertexBuffer;
    GLuint wire_vertexBuffer;
    GLint Sampler;
    GLint TextureCoord;
    GLint TEXTURE;
    GLint FXEDLIGHT;


};


/**
 * File: programData.hpp
 * Version: 1.0
 * @module Surface
 */

/** 
 * Last modified on December 5 2011 by dazar
 * -----------------------------------------------------
 * This interface is incharge of all the variables and information requiered to render a frame in OpenGL. 
 * @class programData
 */



struct ProgramIdentifiers {
    GLuint alg_surface_glsl_program;
    GLuint wireframe_glsl_program;
};

class programData
{
	public:
    
    
        //agregue los colorG2, etc para la segunda cara.
		static float rotationX, rotationY, rotationZ, Shininess, colorR, colorG, colorB, colorR2, colorG2, colorB2, lposX, lposY ,lposZ ;
        //Estos son los parametros de tamaño de esfera, redius para zoom y los otros 2 para bajar la resolucion
        //default radius 1.0, slices y stacks 20;
    
    /**
     * the zoom radius, radius of BB sphere to pass to fragment shader for raytrace.  
     * @property radius
     * @type {float}
     * @default 5
     */
        static float radius;
    /**
     * the zoom radius change speed.
     * @property zoomSpeed
     * @type {float}
     * @default 10
     */
    static float zoomSpeed;
    /**
     * The texture to load.
     * @property textureFileName
     * @type {char *}
     * @default 5
     */
        static char  * textureFileName;

        static mat4 rot;
    /**
     * if true we show the BB with a wireframe.  
     * @property wireFrame
     * @type {bool}
     * @default true
     */
        static bool wireFrame;

    /**
     * if true use toon Shader instead of color.
     * @property toonShader
     * @type {bool}
     * @default true
     */
    static bool toonShader;

    /**
     * if true use Texture instead of color.
     * @property textureEnable
     * @type {bool}
     * @default true
     */
    static bool textureEnable;
    /**
     * if true we use a panoramic camera, else a orthogonal.  
     * @property panoramic
     * @type {bool}
     * @default false
     */
        static bool panoramic;
    /**
     * if true we use a black background, else a white one.
     * @property backgroundBlack
     * @type {bool}
     * @default false
     */
    static bool backgroundBlack;
    
    /**
     * if true Lights are moving with the surface.
     * @property lightState
     * @type {bool}
     * @default false
     */
    static bool lightState;

    /**
     * it is the parametric surface to use as BB.  
     * @property currentSurface
     * @type {int}
     * @default 1
     */
        static int currentSurface, SurfaceCount;
    /**
     * it has all the pointers to opengl reserved memory.  
     * @property shaderHandle
     * @type {ProgramHandle}
     */
        static ProgramHandle shaderHandle;
    
    /**
     * Usage:  InitializeProgramData();
     * ----------------------------------
     * Initialize all OpenGL requiered variables for our shaders. 
     * @method InitializeProgramData
     * @return void
     */    
        static void InitializeProgramData();
    

    /**
     * Usage:  SetEye();
     * ----------------------------------
     * Sets the eye position to the vertex shader, we need this to do the raytrace. 
     * @method SetEye
     * @return void
     */

    void static SetEye();

    /**
     * Usage:  UpdateColor();
     * ----------------------------------
     * Updates color of the algebraic surface render.
     * @method UpdateColor
     */
        void static UpdateColor();

    /**
     * Usage:  setLightFixed(lightSwitch);
     * ----------------------------------
     * Set the lights moving or fixed and place them in the right position in each case.
     * @method UpdateColor
     */
    
        void static setLightFixed(bool lightSwitch);

    
    /**
     * Usage:  UpdateColor(r,g,b);
     * ----------------------------------
     * Updates the primary color rgb of the algebraic surface render. 
     * @method UpdateColor
     * @param red {float} red value [0,1]
     * @param green {float} red value [0,1]
     * @param blue {float} red value [0,1]
     */
        void static UpdateColor(float red, float green, float blue);
    
    /**
     * Usage:  UpdateColor2(r,g,b);
     * ----------------------------------
     * Updates the secondary color rgb of the algebraic surface render. 
     * @method UpdateColor2
     * @param red {float} red value [0,1]
     * @param green {float} red value [0,1]
     * @param blue {float} red value [0,1]
     */
    
        void static UpdateColor2(float red, float green, float blue);

    /**
     * Usage:  UpdateRadius(r);
     * ----------------------------------
     * Updates the radius value we pass to the shader for intersection. 
     * @method UpdateRadius
     * @param radius {float} new radius value
     */

        void static UpdateRadius(float Radius);
    /**
     * Usage:  setCellShade(cellshading);
     * ----------------------------------
     * Enables or disable the CellShading mode in render.
     * @method setCellShade
     * @param cellshading {bool} new radius value
     */
    void static setCellShade(bool cellshading);
    /**
     * Usage:  setTexture(texture);
     * ----------------------------------
     * Enables or disable the Texture mode in render.
     * @method setCellShade
     * @param cellshading {bool} new radius value
     */
    void static setTexture(bool texture);

    /**
     * Usage:  initializeTexture(filename);
     * ----------------------------------
     * Load the texture file into OpenGL.
     * @method setCellShade
     * @param cellshading {bool} new radius value
     */
    void static initializeTexture(char * filename);

    
    static ProgramIdentifiers programs;

	private:
    /**
     * Usage:  setConstant();
     * ----------------------------------
     * Sets constanst values in OpenGL, like lights. 
     * @method setConstant
     * @private
     */
    
        void static setConstant();
    
    
    /**
     * Usage:  GenerateArrays();
     * ----------------------------------
     * Generates vertices array space in OpenGL. 
     * @method GenerateArrays
     * @private
     */

        void static GenerateArrays();
};





#endif
