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
    printf("pase elements 1");
    
    glDrawElements(GL_LINES, drawable.IndexCount, GL_UNSIGNED_SHORT, 0);
    printf("pase elements 1");

    
    
}

void drawSurface(Drawable drawable){
    
    // Draw the surface.
    int stride = 2 * sizeof(vec3);
    //const GLvoid* offset = (const GLvoid*) sizeof(vec3);
    GLint position = programData::shaderHandle.wire_attr_pos;
    glBindBuffer(GL_ARRAY_BUFFER, drawable.VertexBuffer);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, stride, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, drawable.IndexBuffer);
    printf("llege elements 2");
    glDrawElements(GL_TRIANGLES, drawable.IndexCount, GL_UNSIGNED_SHORT, 0);
    printf("pase elements 2");
    
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
	Matrix4x4 t, s, modelview_inv, modelView, rx, ry, rz;
	//Para el zoom parametrizar scale_matrix
	//Para rotacion setear las variables de rotation_matrix
	//Traslacion si es necesario usar la matriz
    scale_matrix( 1, 1, 1, s );
    
	translation_matrix( 0.0, 0.0, -500 , t );
    
    mat4 m_translation, modelview, projection;
    m_translation = mat4::Translate(0, 0, -1000);
    Quaternion quaternion1;
    mat4 rotation = quaternion1.ToMatrix();
    modelview = programData::rot * m_translation;

//    mult_matrix( t, s, modelView );

//	rotation_matrix( 1.0f, 0.0f, 0.0f, programData::rotationX, rx );
//	rotation_matrix( 0.0f, 1.0f, 0.0f, programData::rotationY, ry );
//	rotation_matrix( 0.0f, 0.0f, 1.0f, programData::rotationZ, rz );
   // printf("rotx = %f rot y = %f rotz= %f\n", programData::rotationX, programData::rotationY,programData::rotationZ );
	
    Matrix4x4 aux;
    modelview.toMatrix4x4(aux);

//	mult_matrix( aux, rx, aux );
//	mult_matrix( aux, ry, aux );
//	mult_matrix( aux, rz, aux );

	invert_matrix( aux, modelview_inv );
    
    
	Matrix4x4 projectionOld;
    //rotationX++;
    printf("programData::radius %f \n", programData::radius);
    ortho(programData::radius, -1000, 2000, projectionOld);
    
    
    projection = mat4::Ortho(-programData::radius, programData::radius, -programData::radius, programData::radius, 0.1, 2000);
    
    //printf("radius = %f\n", radius);
    //printf("Rotaxion x = %f, y=%f, z=%f \n", rotationX, rotationY, rotationZ);
    
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT ); checkGLError( AT );
    
	// enable blending
	glEnable (GL_BLEND);
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    
	// set culling properties
	glFrontFace( GL_CCW );
	glCullFace( GL_BACK );/*
    printf("aux\n");
    for (int i = 0; i<4; i++) {
        for (int j=0; j<4; j++) {
            printf("  %f", aux[i*4+j]);
        }
        printf("\n");

    }

    printf("modelView\n");
    for (int i = 0; i<4; i++) {
        for (int j=0; j<4; j++) {
            printf("  %f", modelview.Pointer()[i*4+j]);
        }
        printf("\n");
        
    }
*/
    printf("llege a los draw\n");
    if(programData::debug)
        // draw wireframe sphere
	{
        glDisable( GL_CULL_FACE );
        
        GLuint glsl_program = programData::programs.wireframe_glsl_program;
        glUseProgram( glsl_program ); checkGLError( AT );
                
        glUniformMatrix4fv( programData::shaderHandle.wire_modelview, 1, GL_FALSE, aux ); checkGLError( AT );
        glUniformMatrix4fv( programData::shaderHandle.wire_projection, 1, GL_FALSE, projection.Pointer() ); checkGLError( AT );
            drawWire(drawable);
 	}
	// draw solid sphere, which is used for raycasting
	{

		glEnable( GL_CULL_FACE );
        checkGLError( AT );
        
		GLuint glsl_program = programData::programs.alg_surface_glsl_program;
		glUseProgram( glsl_program ); checkGLError( AT );
                
                
		glUniformMatrix4fv( programData::shaderHandle.u_modelview, 1, GL_FALSE, aux ); checkGLError( AT );
		glUniformMatrix4fv( programData::shaderHandle.u_modelview_inv, 1, GL_FALSE, modelview_inv ); checkGLError( AT );
		glUniformMatrix4fv( programData::shaderHandle.u_projection, 1, GL_FALSE, projection.Pointer() ); checkGLError( AT );
        drawSurface(drawable);

	}
	checkGLError( AT );
    printf("pase a los draw\n");
    
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