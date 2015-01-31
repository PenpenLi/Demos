//
//  sphere.h
//  
//
//  Created by Xiaobin Li on 10/31/14.
//
//

#ifndef _sphere_h
#define _sphere_h
#include "cocos2d.h"

#define ES_PI (3.14159265f)

int GenCircle(int numSlices, float radius,
              GLfloat **vertices, GLfloat **normals,
              GLfloat **texCoords, GLushort **indices);

//
/// \brief Generates geometry for a sphere.  Allocates memory for the vertex data and stores
///        the results in the arrays.  Generate index list for a TRIANGLE_STRIP
/// \param numSlices The number of slices in the sphere
/// \param vertices If not NULL, will contain array of float3 positions
/// \param normals If not NULL, will contain array of float3 normals
/// \param texCoords If not NULL, will contain array of float2 texCoords
/// \param indices If not NULL, will contain the array of indices for the triangle strip
/// \return The number of indices required for rendering the buffers (the number of indices stored in the indices array
///         if it is not NULL ) as a GL_TRIANGLE_STRIP
//
int GenSphere(int numSlices, float radius,
              GLfloat **vertices, GLfloat **normals,
              GLfloat **texCoords, GLushort **indices,
              int *numVertices);

#endif
