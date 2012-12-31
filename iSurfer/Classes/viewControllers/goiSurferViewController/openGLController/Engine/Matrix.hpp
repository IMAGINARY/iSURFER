#pragma once
#include "Vector.hpp"
#include "stdio.h"

/**
 * File: Matrix.hpp
 * Version: 1.0
 * @module Engine
 */

/** 
 * Last modified on February 13 2012 by dazar
 * -----------------------------------------------------
 * This interface provides access to a Matrix library. Matrix2, Matrix3, Matrix4.
 * It is based on the book "iPhone 3D Programming" with some added functionality like matrix inverse.
 * 
 * @class Matrix
 */


typedef float Matrix4x4[16];

template <typename T>
struct Matrix2 {
    Matrix2()
    {
        x.x = 1; x.y = 0;
        y.x = 0; y.y = 1;
    }
    Matrix2(const T* m)
    {
        x.x = m[0]; x.y = m[1];
        y.x = m[2]; y.y = m[3];
    }
    vec2 x;
    vec2 y;
};

template <typename T>
struct Matrix3 {
    Matrix3()
    {
        x.x = 1; x.y = 0; x.z = 0;
        y.x = 0; y.y = 1; y.z = 0;
        z.x = 0; z.y = 0; z.z = 1;
    }
    Matrix3(const T* m)
    {
        x.x = m[0]; x.y = m[1]; x.z = m[2];
        y.x = m[3]; y.y = m[4]; y.z = m[5];
        z.x = m[6]; z.y = m[7]; z.z = m[8];
    }
    Matrix3 Transposed() const
    {
        Matrix3 m;
        m.x.x = x.x; m.x.y = y.x; m.x.z = z.x;
        m.y.x = x.y; m.y.y = y.y; m.y.z = z.y;
        m.z.x = x.z; m.z.y = y.z; m.z.z = z.z;
        return m;
    }
    const T* Pointer() const
    {
        return &x.x;
    }
    vec3 x;
    vec3 y;
    vec3 z;
};

template <typename T>
struct Matrix4 {
    Matrix4()
    {
        x.x = 1; x.y = 0; x.z = 0; x.w = 0;
        y.x = 0; y.y = 1; y.z = 0; y.w = 0;
        z.x = 0; z.y = 0; z.z = 1; z.w = 0;
        w.x = 0; w.y = 0; w.z = 0; w.w = 1;
    }
    Matrix4(const Matrix3<T>& m)
    {
        x.x = m.x.x; x.y = m.x.y; x.z = m.x.z; x.w = 0;
        y.x = m.y.x; y.y = m.y.y; y.z = m.y.z; y.w = 0;
        z.x = m.z.x; z.y = m.z.y; z.z = m.z.z; z.w = 0;
        w.x = 0; w.y = 0; w.z = 0; w.w = 1;
    }
    Matrix4(const T* m)
    {
        x.x = m[0];  x.y = m[1];  x.z = m[2];  x.w = m[3];
        y.x = m[4];  y.y = m[5];  y.z = m[6];  y.w = m[7];
        z.x = m[8];  z.y = m[9];  z.z = m[10]; z.w = m[11];
        w.x = m[12]; w.y = m[13]; w.z = m[14]; w.w = m[15];
    }
    Matrix4 operator * (const Matrix4& b) const
    {
        Matrix4 m;
        m.x.x = x.x * b.x.x + x.y * b.y.x + x.z * b.z.x + x.w * b.w.x;
        m.x.y = x.x * b.x.y + x.y * b.y.y + x.z * b.z.y + x.w * b.w.y;
        m.x.z = x.x * b.x.z + x.y * b.y.z + x.z * b.z.z + x.w * b.w.z;
        m.x.w = x.x * b.x.w + x.y * b.y.w + x.z * b.z.w + x.w * b.w.w;
        m.y.x = y.x * b.x.x + y.y * b.y.x + y.z * b.z.x + y.w * b.w.x;
        m.y.y = y.x * b.x.y + y.y * b.y.y + y.z * b.z.y + y.w * b.w.y;
        m.y.z = y.x * b.x.z + y.y * b.y.z + y.z * b.z.z + y.w * b.w.z;
        m.y.w = y.x * b.x.w + y.y * b.y.w + y.z * b.z.w + y.w * b.w.w;
        m.z.x = z.x * b.x.x + z.y * b.y.x + z.z * b.z.x + z.w * b.w.x;
        m.z.y = z.x * b.x.y + z.y * b.y.y + z.z * b.z.y + z.w * b.w.y;
        m.z.z = z.x * b.x.z + z.y * b.y.z + z.z * b.z.z + z.w * b.w.z;
        m.z.w = z.x * b.x.w + z.y * b.y.w + z.z * b.z.w + z.w * b.w.w;
        m.w.x = w.x * b.x.x + w.y * b.y.x + w.z * b.z.x + w.w * b.w.x;
        m.w.y = w.x * b.x.y + w.y * b.y.y + w.z * b.z.y + w.w * b.w.y;
        m.w.z = w.x * b.x.z + w.y * b.y.z + w.z * b.z.z + w.w * b.w.z;
        m.w.w = w.x * b.x.w + w.y * b.y.w + w.z * b.z.w + w.w * b.w.w;
        return m;
    }
    
    
    static Matrix4<T> Ortho(T left, T right, T bottom, T top, T near, T far)
    {
        T a = 2.0f / (right - left);
        T b = 2.0f / (top - bottom);
        T c = -2.0f / (far - near);
        T tx = -(right + left) / (right - left);
        T ty = -(top + bottom) / (top - bottom);
        T tz = -(far + near) / (far - near);
        Matrix4 m;
        m.x.x = a; m.x.y = 0; m.x.z = 0; m.w.x = tx;
        m.y.x = 0; m.y.y = b; m.y.z = 0; m.w.y = ty;
        m.z.x = 0; m.z.y = 0; m.z.z = c; m.w.z = tz;
        m.x.w = 0; m.y.w = 0; m.z.w = 0; m.w.w = 1.0;
        return m;
    }
    
    static Matrix4<T> LookAt(vec3 eye, vec3 target, vec3 up)
    {
        vec3 zaxis = (target - eye).Normalized();    // The "look-at" vector.

        vec3  xaxis = (up.Cross(zaxis)).Normalized();// The "right" vector.
        vec3  yaxis = zaxis.Cross(xaxis);     // The "up" vector.
        
        
        Matrix4 m, translation;
        m.x.x = xaxis.x; m.x.y = yaxis.x; m.x.z = zaxis.x; m.w.x = 0;
        m.y.x = xaxis.y; m.y.y = yaxis.y; m.y.z = zaxis.y; m.w.y = 0;
        m.z.x = xaxis.z; m.z.y = yaxis.z; m.z.z = zaxis.z; m.w.z = 0;
        m.x.w = 0;       m.y.w = 0;       m.z.w = 0;       m.w.w = 1;

           
        translation = Translate(-eye.x, -eye.y,-eye.z);
  
            // Create a 4x4 translation matrix by negating the eye position.
            // Combine the orientation and translation to compute the view matrix
        //http://3dgep.com/?p=1700
        return ( translation * m );
    

    }
    
    Matrix4& operator *= (const Matrix4& b)
    {
        Matrix4 m = *this * b;
        return (*this = m);
    }
    Matrix4 Transposed() const
    {
        Matrix4 m;
        m.x.x = x.x; m.x.y = y.x; m.x.z = z.x; m.x.w = w.x;
        m.y.x = x.y; m.y.y = y.y; m.y.z = z.y; m.y.w = w.y;
        m.z.x = x.z; m.z.y = y.z; m.z.z = z.z; m.z.w = w.z;
        m.w.x = x.w; m.w.y = y.w; m.w.z = z.w; m.w.w = w.w;
        return m;
    }
    Matrix3<T> ToMat3() const
    {
        Matrix3<T> m;
        m.x.x = x.x; m.y.x = y.x; m.z.x = z.x;
        m.x.y = x.y; m.y.y = y.y; m.z.y = z.y;
        m.x.z = x.z; m.y.z = y.z; m.z.z = z.z;
        return m;
    }
    const T* Pointer() const
    {
        return &x.x;
    }
    static Matrix4<T> Identity()
    {
        return Matrix4();
    }
    static Matrix4<T> Translate(T x, T y, T z)
    {
        Matrix4 m;
        m.x.x = 1; m.x.y = 0; m.x.z = 0; m.x.w = 0;
        m.y.x = 0; m.y.y = 1; m.y.z = 0; m.y.w = 0;
        m.z.x = 0; m.z.y = 0; m.z.z = 1; m.z.w = 0;
        m.w.x = x; m.w.y = y; m.w.z = z; m.w.w = 1;
        return m;
    }
    static Matrix4<T> Scale(T s)
    {
        Matrix4 m;
        m.x.x = s; m.x.y = 0; m.x.z = 0; m.x.w = 0;
        m.y.x = 0; m.y.y = s; m.y.z = 0; m.y.w = 0;
        m.z.x = 0; m.z.y = 0; m.z.z = s; m.z.w = 0;
        m.w.x = 0; m.w.y = 0; m.w.z = 0; m.w.w = 1;
        return m;
    }
    
    static Matrix4<T> Scale(T x, T y, T z)
    {
        Matrix4 m;
        m.x.x = x; m.x.y = 0; m.x.z = 0; m.x.w = 0;
        m.y.x = 0; m.y.y = y; m.y.z = 0; m.y.w = 0;
        m.z.x = 0; m.z.y = 0; m.z.z = z; m.z.w = 0;
        m.w.x = 0; m.w.y = 0; m.w.z = 0; m.w.w = 1;
        return m;
    }

    static Matrix4<T> Rotate(T degrees)
    {
        T radians = degrees * 3.14159f / 180.0f;
        T s = std::sin(radians);
        T c = std::cos(radians);
        
        Matrix4 m;
        m.x.x =  c; m.x.y = s; m.x.z = 0; m.x.w = 0;
        m.y.x = -s; m.y.y = c; m.y.z = 0; m.y.w = 0;
        m.z.x =  0; m.z.y = 0; m.z.z = 1; m.z.w = 0;
        m.w.x =  0; m.w.y = 0; m.w.z = 0; m.w.w = 1;
        return m;
    }
    
    static Matrix4<T> Perspective(float fovy, float aspect, float zNear, float zFar)
    {
        float xmin, xmax, ymin, ymax;
        ymax = zNear * tan(fovy * M_PI / 360.0);
        ymin = -ymax;
        xmin = ymin * aspect;
        xmax = ymax * aspect;
        return Frustum(xmin, xmax, ymin, ymax, zNear, zFar);
    }

    
    static Matrix4<T> Frustum(T left, T right, T bottom, T top, T near, T far)
    {
        T a = 2 * near / (right - left);
        T b = 2 * near / (top - bottom);
        T c = (right + left) / (right - left);
        T d = (top + bottom) / (top - bottom);
        T e = - (far + near) / (far - near);
        T f = -2 * far * near / (far - near);
        Matrix4 m;
        m.x.x = a; m.x.y = 0; m.x.z = 0; m.x.w = 0;
        m.y.x = 0; m.y.y = b; m.y.z = 0; m.y.w = 0;
        m.z.x = c; m.z.y = d; m.z.z = e; m.z.w = -1;
        m.w.x = 0; m.w.y = 0; m.w.z = f; m.w.w = 1;
        return m;
    }
    static Matrix4<T> fromCATransform3D(vec4 x, vec4 y, vec4 z , vec4 w)
    {
        Matrix4 m;
        m.x = x;
        m.y = y;
        m.z = z;
        m.w = w;
        return m;
    }

    void toMatrix4x4(Matrix4x4 result) 
    {
#define M(row,col)  result[col*4+row]
        M(0,0) = x.x;     M(0,1) = y.x;  M(0,2) = z.x;      M(0,3) = w.x;
        M(1,0) = x.y;     M(1,1) = y.y;  M(1,2) = z.y;      M(1,3) = w.y;
        M(2,0) = x.z;     M(2,1) = y.z;  M(2,2) = z.z;      M(2,3) = w.z;
        M(3,0) = x.w;     M(3,1) = y.w;  M(3,2) = z.w;      M(3,3) = w.w;
#undef M
    }
    
     Matrix4<T> invert_matrix() 
    {
        Matrix4x4 aux, result;
        toMatrix4x4(aux);

        invert_matrix(aux, result);
    
        return Matrix4(result); 
    }
    
    
    
    
#define MAT(m,r,c) (m)[(c)*4+(r)]
#define SWAP_ROWS(a, b) { float *_tmp = a; (a)=(b); (b)=_tmp; }
#define FABSF(x)   ((float) fabs(x))
    bool invert_matrix( const Matrix4x4 m, Matrix4x4 result  )
    {
        float *out = result;
        float wtmp[4][8];
        float m0, m1, m2, m3, s;
        float *r0, *r1, *r2, *r3;
        
        r0 = wtmp[0], r1 = wtmp[1], r2 = wtmp[2], r3 = wtmp[3];
        
        r0[0] = MAT(m,0,0), r0[1] = MAT(m,0,1),
        r0[2] = MAT(m,0,2), r0[3] = MAT(m,0,3),
        r0[4] = 1.0, r0[5] = r0[6] = r0[7] = 0.0,
        
        r1[0] = MAT(m,1,0), r1[1] = MAT(m,1,1),
        r1[2] = MAT(m,1,2), r1[3] = MAT(m,1,3),
        r1[5] = 1.0, r1[4] = r1[6] = r1[7] = 0.0,
        
        r2[0] = MAT(m,2,0), r2[1] = MAT(m,2,1),
        r2[2] = MAT(m,2,2), r2[3] = MAT(m,2,3),
        r2[6] = 1.0, r2[4] = r2[5] = r2[7] = 0.0,
        
        r3[0] = MAT(m,3,0), r3[1] = MAT(m,3,1),
        r3[2] = MAT(m,3,2), r3[3] = MAT(m,3,3),
        r3[7] = 1.0, r3[4] = r3[5] = r3[6] = 0.0;
        
        /* choose pivot - or die */
        if (FABSF(r3[0])>FABSF(r2[0])) SWAP_ROWS(r3, r2);
        if (FABSF(r2[0])>FABSF(r1[0])) SWAP_ROWS(r2, r1);
        if (FABSF(r1[0])>FABSF(r0[0])) SWAP_ROWS(r1, r0);
        if (0.0 == r0[0])  return false;
        
        /* eliminate first variable     */
        m1 = r1[0]/r0[0]; m2 = r2[0]/r0[0]; m3 = r3[0]/r0[0];
        s = r0[1]; r1[1] -= m1 * s; r2[1] -= m2 * s; r3[1] -= m3 * s;
        s = r0[2]; r1[2] -= m1 * s; r2[2] -= m2 * s; r3[2] -= m3 * s;
        s = r0[3]; r1[3] -= m1 * s; r2[3] -= m2 * s; r3[3] -= m3 * s;
        s = r0[4];
        if (s != 0.0) { r1[4] -= m1 * s; r2[4] -= m2 * s; r3[4] -= m3 * s; }
        s = r0[5];
        if (s != 0.0) { r1[5] -= m1 * s; r2[5] -= m2 * s; r3[5] -= m3 * s; }
        s = r0[6];
        if (s != 0.0) { r1[6] -= m1 * s; r2[6] -= m2 * s; r3[6] -= m3 * s; }
        s = r0[7];
        if (s != 0.0) { r1[7] -= m1 * s; r2[7] -= m2 * s; r3[7] -= m3 * s; }
        
        /* choose pivot - or die */
        if (FABSF(r3[1])>FABSF(r2[1])) SWAP_ROWS(r3, r2);
        if (FABSF(r2[1])>FABSF(r1[1])) SWAP_ROWS(r2, r1);
        if (0.0 == r1[1])  return false;
        
        /* eliminate second variable */
        m2 = r2[1]/r1[1]; m3 = r3[1]/r1[1];
        r2[2] -= m2 * r1[2]; r3[2] -= m3 * r1[2];
        r2[3] -= m2 * r1[3]; r3[3] -= m3 * r1[3];
        s = r1[4]; if (0.0 != s) { r2[4] -= m2 * s; r3[4] -= m3 * s; }
        s = r1[5]; if (0.0 != s) { r2[5] -= m2 * s; r3[5] -= m3 * s; }
        s = r1[6]; if (0.0 != s) { r2[6] -= m2 * s; r3[6] -= m3 * s; }
        s = r1[7]; if (0.0 != s) { r2[7] -= m2 * s; r3[7] -= m3 * s; }
        
        /* choose pivot - or die */
        if (FABSF(r3[2])>FABSF(r2[2])) SWAP_ROWS(r3, r2);
        if (0.0 == r2[2])  return false;
        
        /* eliminate third variable */
        m3 = r3[2]/r2[2];
        r3[3] -= m3 * r2[3], r3[4] -= m3 * r2[4],
        r3[5] -= m3 * r2[5], r3[6] -= m3 * r2[6],
        r3[7] -= m3 * r2[7];
        
        /* last check */
        if (0.0 == r3[3]) return false;
        
        s = 1.0F/r3[3];             /* now back substitute row 3 */
        r3[4] *= s; r3[5] *= s; r3[6] *= s; r3[7] *= s;
        
        m2 = r2[3];                 /* now back substitute row 2 */
        s  = 1.0F/r2[2];
        r2[4] = s * (r2[4] - r3[4] * m2), r2[5] = s * (r2[5] - r3[5] * m2),
        r2[6] = s * (r2[6] - r3[6] * m2), r2[7] = s * (r2[7] - r3[7] * m2);
        m1 = r1[3];
        r1[4] -= r3[4] * m1, r1[5] -= r3[5] * m1,
        r1[6] -= r3[6] * m1, r1[7] -= r3[7] * m1;
        m0 = r0[3];
        r0[4] -= r3[4] * m0, r0[5] -= r3[5] * m0,
        r0[6] -= r3[6] * m0, r0[7] -= r3[7] * m0;
        
        m1 = r1[2];                 /* now back substitute row 1 */
        s  = 1.0F/r1[1];
        r1[4] = s * (r1[4] - r2[4] * m1), r1[5] = s * (r1[5] - r2[5] * m1),
        r1[6] = s * (r1[6] - r2[6] * m1), r1[7] = s * (r1[7] - r2[7] * m1);
        m0 = r0[2];
        r0[4] -= r2[4] * m0, r0[5] -= r2[5] * m0,
        r0[6] -= r2[6] * m0, r0[7] -= r2[7] * m0;
        
        m0 = r0[1];                 /* now back substitute row 0 */
        s  = 1.0F/r0[0];
        r0[4] = s * (r0[4] - r1[4] * m0), r0[5] = s * (r0[5] - r1[5] * m0),
        r0[6] = s * (r0[6] - r1[6] * m0), r0[7] = s * (r0[7] - r1[7] * m0);
        
        MAT(out,0,0) = r0[4]; MAT(out,0,1) = r0[5],
        MAT(out,0,2) = r0[6]; MAT(out,0,3) = r0[7],
        MAT(out,1,0) = r1[4]; MAT(out,1,1) = r1[5],
        MAT(out,1,2) = r1[6]; MAT(out,1,3) = r1[7],
        MAT(out,2,0) = r2[4]; MAT(out,2,1) = r2[5],
        MAT(out,2,2) = r2[6]; MAT(out,2,3) = r2[7],
        MAT(out,3,0) = r3[4]; MAT(out,3,1) = r3[5],
        MAT(out,3,2) = r3[6]; MAT(out,3,3) = r3[7];
        
        return true;
    }

    
    vec4 x;
    vec4 y;
    vec4 z;
    vec4 w;
};

typedef Matrix2<float> mat2;
typedef Matrix3<float> mat3;
typedef Matrix4<float> mat4;
