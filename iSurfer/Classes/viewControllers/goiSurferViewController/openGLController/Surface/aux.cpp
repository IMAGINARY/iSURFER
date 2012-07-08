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
#include "matrix.h"
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
    //printf("\n\n\ndebug = %d \n\n\n", programData::debug);
    //programData::rotationX += 0.1f ;
	checkGLError( AT );
    //printf("Display empieza \n");
	// setup matrices
    //mat4 projection;
	Matrix4x4 s, modelview_inv, modelView;//, rx, ry, rz;
	//Para el zoom parametrizar scale_matrix
	//Para rotacion setear las variables de rotation_matrix
	//Traslacion si es necesario usar la matriz
    scale_matrix( 0.75, 1, 1, s );
    Matrix4x4 project, rota, look;
    
	//translation_matrix( 0.0, 0.0, -0 , t );
    
    //mat4 m_translation, projection;
    //m_translation = mat4::Translate(0, 0,-programData::radius );//-10000);
    //mat4 modelview;
    //Quaternion quaternion1;
    //mat4 rotation = quaternion1.ToMatrix();
    
    //modelview = programData::rot;//* m_translation;
    //modelview.Scale(1,1,1);
    programData::rot.toMatrix4x4(rota);
    
    //    mult_matrix( t, s, modelView );
    
    //	rotation_matrix( 1.0f, 0.0f, 0.0f, programData::rotationX, rx );
    //	rotation_matrix( 0.0f, 1.0f, 0.0f, programData::rotationY, ry );
    //	rotation_matrix( 0.0f, 0.0f, 1.0f, programData::rotationZ, rz );
    //matrixRotateX( programData::rotationX,rx);
    //    matrixRotateY( programData::rotationY,ry);
    
    //matrixRotateZ( programData::rotationZ,rz);
    // printf("rotx = %f rot y = %f rotz= %f\n", programData::rotationX, programData::rotationY,programData::rotationZ );
	mat4 cameraT, projection;
    
    
    cameraT = mat4::LookAt(vec3(0, 0, 120), vec3(0 , 0, 0), vec3(0, 1, 0));
    cameraT.toMatrix4x4(look);
    
    
    //modelview = modelview * cameraT;
    
    //	mult_matrix( look, rx, other );
	//mult_matrix( other, ry, other );
    //	mult_matrix( other, rz, other );
    mult_matrix( look, s, look);
    
    mult_matrix( look, rota, modelView);
    
    /* 
     printf("other\n");
     for (int i = 0; i<4; i++) {
     for (int j=0; j<4; j++) {
     printf("  %f", look[i*4+j]);
     }
     printf("\n");
     
     }
     
     printf("modelView\n");
     for (int i = 0; i<4; i++) {
     for (int j=0; j<4; j++) {
     printf("  %f", cameraT.Pointer()[i*4+j]);
     }
     printf("\n");
     
     }
     
     */
    
    //rotationX++;
    //printf("programData::radius %f \n", programData::radius);
    //ortho(programData::radius+1, -1000, 2000, projectionOld);
    
    
    projection = mat4::Ortho(-programData::radius, programData::radius, -programData::radius, programData::radius, -600.1, 1000);
    //projection = mat4::Frustum(-programData::radius/2, programData::radius/2, -programData::radius/2, programData::radius/2, 0.1, 1000);    //printf("radius = %f\n", radius);
    //printf("Rotaxion x = %f, y=%f, z=%f \n", rotationX, rotationY, rotationZ);
    
    //frustum_matrix(-programData::radius, programData::radius, -programData::radius, programData::radius, 5, programData::radius * 2 +10, projectionOld);
    //perspective_projection_matrix( 60.0, 1.0, 0.1, 1000.0, projectionOld );
    //perspective( 60.0, 1.0, programData::radius, 1000.0, projectionOld );
    //modelview.toMatrix4x4(aux);
    projection.toMatrix4x4(project);
    
    invert_matrix( modelView, modelview_inv );
    
    mult_matrix( project, modelView, modelView);
    
    //modelview = modelview * projection;
    
    
    
    
    
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
        
        glUniformMatrix4fv( programData::shaderHandle.wire_modelview, 1, GL_FALSE, modelView ); checkGLError( AT );
        drawWire(drawable);
 	}
	// draw solid sphere, which is used for raycasting
	{
        
		glEnable( GL_CULL_FACE );
        checkGLError( AT );
        
		GLuint glsl_program = programData::programs.alg_surface_glsl_program;
		glUseProgram( glsl_program ); checkGLError( AT );
        
        
		glUniformMatrix4fv( programData::shaderHandle.u_modelview, 1, GL_FALSE, modelView ); checkGLError( AT );
		glUniformMatrix4fv( programData::shaderHandle.u_modelview_inv, 1, GL_FALSE, modelview_inv ); checkGLError( AT );
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