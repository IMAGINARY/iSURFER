//
//  surfaceRender.cpp
//  iSurfer
//
//  Created by Daniel Jose Azar on 4/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "surfaceRender.h"

#include "programData.hpp"
#include "error.hpp"
#include "Vector.hpp"
#include "Matrix.hpp"
#include "Quaternion.hpp" 

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>

using namespace std;

void drawWire(Drawable drawable){

    int stride = 2 * sizeof(vec3);
    GLint position = programData::shaderHandle.wire_attr_pos;
    
    glBindBuffer(GL_ARRAY_BUFFER, drawable.VertexBuffer);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, stride, 0);

    glDrawElements(GL_LINES, drawable.IndexCount-1, GL_UNSIGNED_SHORT, 0);
    
}

void drawSurface(Drawable drawable){
    
    // Draw the surface.
    int stride = 2 * sizeof(vec3);
    //const GLvoid* offset = (const GLvoid*) sizeof(vec3);

    const GLvoid* texCoordOffset = (const GLvoid*) (2 * sizeof(vec3));
    GLint position = programData::shaderHandle.wire_attr_pos;

    GLint texCoord = programData::shaderHandle.TextureCoord;
    glBindBuffer(GL_ARRAY_BUFFER, drawable.VertexBuffer);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, stride, 0);
    glVertexAttribPointer(texCoord, 2, GL_FLOAT, GL_FALSE, stride, texCoordOffset);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, drawable.IndexBuffer);
    glDrawElements(GL_TRIANGLES, drawable.IndexCount, GL_UNSIGNED_SHORT, 0);

}



void surfaceRender::resize( int w, int h )
{
	// always use quadratic viewport
	if( w > h )
		glViewport( 0, 0, (GLsizei) h, (GLsizei) h );
	else
		glViewport( 0, 0, (GLsizei) w, (GLsizei) w );	
}

void surfaceRender::display(Drawable drawable, Quaternion orientation)
{
    
    mat4 project; 
    mat4 s, cameraT, model, modelView, projectionModelView, trans, modelViewInv;
    
    if( ! programData::panoramic)
    {
        s = mat4::Scale(0.75, 1, 1);
        
        cameraT = mat4::LookAt(vec3(0, 0, 120), vec3(0 , 0, 0), vec3(0, -1, 0));
        
        model = s * cameraT;
        
        
        modelView = Matrix4< float >(orientation.ToMatrix()) * model ;
      
//        modelView = programData::rot * model ;
        
        project = mat4::Ortho(-programData::radius, programData::radius, -programData::radius, programData::radius, -600.1, 1000);
                
        modelViewInv = modelView.invert_matrix();

        projectionModelView = modelView * project;
     
        
    }else{

        
        s = mat4::Scale(0.125f, 0.125f, 0.125f);

        cameraT =  mat4::Translate(0.0, 0.0, -programData::radius * tan(30.0 * M_PI / 360.0));
        
//        model = cameraT * s;
       
//        modelView = model * programData::rot;

        model = s * cameraT;
        
        
        modelView = Matrix4< float >(orientation.ToMatrix()) * model ;
        
        project = mat4::Perspective(60.0, 1.0, 0.1, 300.0);
        
        modelViewInv = modelView.invert_matrix();
        
        projectionModelView = modelView * project;

        
        

    }

    //programData::SetEye();
    
    

	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT ); checkGLError( AT );
    
	// enable blending
	glEnable (GL_BLEND);
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    
	// set culling properties
	glFrontFace( GL_CCW );
	glCullFace( GL_BACK );
    
     
    //printf("drawing frame\n");
    if(programData::wireFrame)
        // draw wireframe sphere
	{
        glDisable( GL_CULL_FACE );
        
        GLuint glsl_program = programData::programs.wireframe_glsl_program;
        glUseProgram( glsl_program ); checkGLError( AT );
                
        glUniformMatrix4fv( programData::shaderHandle.wire_modelview, 1, GL_FALSE, projectionModelView.Pointer() ); checkGLError( AT );
            drawWire(drawable);
 	}
	// draw solid sphere, which is used for raycasting
	{

		glEnable( GL_CULL_FACE );
        checkGLError( AT );
        
		GLuint glsl_program = programData::programs.alg_surface_glsl_program;
		glUseProgram( glsl_program ); checkGLError( AT );
                
                
		glUniformMatrix4fv( programData::shaderHandle.u_modelview, 1, GL_FALSE, projectionModelView.Pointer() ); checkGLError( AT );
		glUniformMatrix4fv( programData::shaderHandle.u_modelview_inv, 1, GL_FALSE, modelViewInv.Pointer() ); checkGLError( AT );
	    drawSurface(drawable);

	}
	checkGLError( AT );
    
    

    
}