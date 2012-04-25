#ifndef __MATRIX_H__
#define __MATRIX_H__

typedef float Matrix4x4[16];

void identity_matrix( Matrix4x4 matrix );
void rotation_matrix( float axis_x, float axis_y, float axis_z, float angle, Matrix4x4 matrix );
void translation_matrix( float translate_x, float translate_y, float translate_z, Matrix4x4 matrix );
void scale_matrix( float scale_x, float scale_y, float scale_z, Matrix4x4 matrix );
void perspective_projection_matrix( float fovy, float aspect, float zNear, float zFar, Matrix4x4 result );
void frustum_matrix( float xmin, float xmax, float ymin, float ymax, float zNear, float zFar, Matrix4x4 result );
void mult_matrix( const Matrix4x4 m1, const Matrix4x4 m2, Matrix4x4 result );
bool invert_matrix( const Matrix4x4 m, Matrix4x4 result );
void ortho( float radius, float nearval, float farval, Matrix4x4 result );
void perspective( float fovy, float aspect, float radius, float zFar, Matrix4x4 result );
float getTranslation(float fovy, float radius);

#endif
