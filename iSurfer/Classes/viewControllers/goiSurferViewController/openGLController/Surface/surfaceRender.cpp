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
//#include "Myvector.h"

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>

using namespace std;

void drawWire(){
    //glEnableVertexAttribArray(0);
    //glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, programData::normalized);
    //glDrawArrays(GL_LINES, 0, STACKS * (SLICES + 1) * 2);
    //glDisableVertexAttribArray(0);
    
    
    
    glBindBuffer(GL_ARRAY_BUFFER, programData::shaderHandle.wire_vertexBuffer);
    glVertexAttribPointer(programData::shaderHandle.wire_attr_pos, 3, GL_FLOAT, GL_FALSE, 0, 0);
    //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, drawable.IndexBuffer);
    //glDrawElements(GL_LINES, drawable.IndexCount, GL_UNSIGNED_SHORT, 0);

    
    
    
    //AdjustRadius(radius, stacks, slices, programData::vertex, programData::normalized);
    //glEnableVertexAttribArray(attr_pos);
    //glVertexAttribPointer( attr_pos, 3, GL_FLOAT, GL_FALSE, 0, programData::vertex );
    
    //printf("\n\n\n debug = %d \n\n\n", programData::debug);
    
    glDrawArrays(GL_LINE_LOOP, 0, (SLICES + 1) * 2* STACKS);
    
    

}

void drawWire(Drawable drawable){

    int stride = 2 * sizeof(vec3);
    //const GLvoid* offset = (const GLvoid*) sizeof(vec3);
    GLint position = programData::shaderHandle.wire_attr_pos;

    glBindBuffer(GL_ARRAY_BUFFER, drawable.VertexBuffer);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, stride, 0);

    glDrawElements(GL_LINES, drawable.IndexCount, GL_UNSIGNED_SHORT, 0);
    
    
}

void drawSurface(Drawable drawable){
    
    // Draw the surface.
    int stride = 2 * sizeof(vec3);
    //const GLvoid* offset = (const GLvoid*) sizeof(vec3);
    GLint position = programData::shaderHandle.wire_attr_pos;
    glBindBuffer(GL_ARRAY_BUFFER, drawable.VertexBuffer);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, stride, 0);
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
void surfaceRender::hola(){
    printf("llego aca\n");
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
        
        modelView = programData::rot * model ;
        
        
       // rotation_matrix( 1.0f, 0.0f, 0.0f, programData::rotationX, rx );
       // rotation_matrix( 0.0f, 1.0f, 0.0f, programData::rotationY, ry );
       // rotation_matrix( 0.0f, 0.0f, 1.0f, programData::rotationZ, rz );
        
        //mult_matrix( modelView, rx, modelView );
       // mult_matrix( modelView, ry, modelView );
        //mult_matrix( modelView, rz, modelView );
        
        
        project = mat4::Ortho(-programData::radius, programData::radius, -programData::radius, programData::radius, -600.1, 1000);
        
        //project = mat4::Frustum(-programData::radius, programData::radius, -programData::radius, programData::radius, -600.1, 1000);
        
        //modelView.invert_matrix( modelview_inv );
       /* printf("modelView\n");
        for (int i = 0; i<4; i++) {
            for (int j=0; j<4; j++) {
                printf("  %f", modelView.Pointer()[i*4+j]);
            }
            printf("\n");
            
        }
        */
/*
        float a[]= {0.8272,0.0069   ,1.0457,         0,
        -0.5727,   -0.6802,    0.4575,    0.0000,
        0.5359,   -0.7330,   -0.4190,         0,
            -64.3025,   87.9584,   50.2843,    1.0000};

        float b[]= {    0.4653,   -0.5727,    0.5359,         0,
            0.0039,   -0.6802,   -0.7330,         0,
            0.5882,    0.4575,   -0.4190,         0,
            0,         0,  120.0000,    1.0000};
        modelView = mat4(b);
        modelViewInv = mat4(a);
  */      
        
        modelViewInv = modelView.invert_matrix();

        projectionModelView = modelView * project;
     
        
    }else{
        //MATRIZ de TRANS para ortho
        
        //translation_matrix( 0.0, 0.0, -programData::radius , t );
        s = mat4::Scale(0.125f, 0.125f, 0.125f);

        cameraT =  mat4::Translate(0.0, 0.0, -programData::radius * tan(30.0 * M_PI / 360.0));
        
        model = cameraT * s;        
       
        modelView = model * programData::rot;

        //rotation_matrix( 1.0f, 0.0f, 0.0f, programData::rotationX, rx );
        //rotation_matrix( 0.0f, 1.0f, 0.0f, programData::rotationY, ry );
        //rotation_matrix( 0.0f, 0.0f, 1.0f, programData::rotationZ, rz );
        
        //mult_matrix( modelView, rx, modelView );
        //mult_matrix( modelView, ry, modelView );
        //mult_matrix( modelView, rz, modelView );
        
        
        modelViewInv = modelView.invert_matrix();
        
        project = mat4::Perspective(60.0, 1.0, 0.1, 300.0);
        
        projectionModelView = project *  modelView;

        
        

    }

    programData::SetEye();
    
    

	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT ); checkGLError( AT );
    
	// enable blending
	glEnable (GL_BLEND);
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    
	// set culling properties
	glFrontFace( GL_CCW );
	glCullFace( GL_BACK );
    
     
    printf("drawing frame\n");
    if(programData::debug)
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
    printf("frame drew\n");
    
    //printf("Termino Display\n");
    
}




/*
 void drawAxis(float radius){
 glBegin(GL_LINES);
 //Axis x Red;
 glColor4f(1, 0, 0,0);
 //Axis y green;
 glColor4f(0, 1, 0,0);
 
 //Axis z blue;
 glColor4f(0, 0, 1,0);
 
 glEnd();
 
 }*/