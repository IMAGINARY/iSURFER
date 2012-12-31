#pragma once
#include "Interfaces.hpp"

/**
 * File: ParametricSurface.hpp
 * Version: 1.0
 * @module Engine
 */

/** 
 * Last modified on February 13 2012 by dazar
 * -----------------------------------------------------
 * This interface provides access to a Matrix library. Matrix2, Matrix3, Matrix4.
 * It is based on the book "iPhone 3D Programming" with some added functionality like matrix inverse.
 * 
 * @class ParametricSurface
 */

struct ParametricInterval {
    ivec2 Divisions;
    vec2 UpperBound;
    vec2 TextureCount;
};

class ParametricSurface : public ISurface {
public:
    /**
     * Usage: i = GetVertexCount();
     * ----------------------------------
     * Returns the number of vertex of the parametric surface. 
     * @method GetVertexCount
     * @return {int} number of vertex.
     */
    int GetVertexCount() const;
    /**
     * Usage: i = GetLineIndexCount();
     * ----------------------------------
     * Returns the number of lines of the parametric surface. 
     * @method GetLineIndexCount
     * @return {int} number of lines.
     */
    int GetLineIndexCount() const;
    /**
     * Usage: i = GetTriangleIndexCount();
     * ----------------------------------
     * Returns the number of triangles of the parametric surface. 
     * @method GetTriangleIndexCount
     * @return {int} number of triangles.
     */
    int GetTriangleIndexCount() const;
    /**
     * Usage: GenerateVertices(vertices, flags);
     * ----------------------------------
     * Generates the vertices of the surface. 
     * @method GenerateVertices
     * @param vertices {vector<float>} vector array of vertices.
     * @param flags {char}.
     */
    void GenerateVertices(vector<float>& vertices, unsigned char flags) const;
    /**
     * Usage: GenerateLineIndices(indices);
     * ----------------------------------
     * Generates the line indexes of the surface. 
     * @method GenerateLineIndices
     * @param vertices {vector<short> &} vector array of lines indexes.
     */
    void GenerateLineIndices(vector<unsigned short>& indices) const;
    /**
     * Usage: GenerateTriangleIndices(vertices);
     * ----------------------------------
     * Generates the triangle indexes of the surface. 
     * @method GenerateTriangleIndices
     * @param vertices {vector<float>} vector array of triangle indexes.
     */
    void GenerateTriangleIndices(vector<unsigned short>& indices) const;
    /**
     * Usage: Zoom(newRadius);
     * ----------------------------------
     * change the zoom of the surface. 
     * @method Zoom
     * @param newRadius {float} change the zoom of the surface.
     */
    virtual void Zoom(const float newRadius)  = 0;

protected:
    void SetInterval(const ParametricInterval& interval);
    virtual vec3 Evaluate(const vec2& domain) const = 0;

    virtual bool InvertNormal(const vec2& domain) const { return false; }
private:
    vec2 ComputeDomain(float i, float j) const;
    ivec2 m_slices;
    ivec2 m_divisions;
    vec2 m_upperBound;
	vec2 m_textureCount;
};
