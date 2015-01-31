//
//  sphere.cpp
//  TheKing
//
//  Created by Xiaobin Li on 12/18/14.
//
//

#include "GLHelper.h"

int GenCircle(int numSlices, float R,
              GLfloat **vertices, GLfloat **normals,
              GLfloat **texCoords, GLushort **indices) {
    int numVertices = numSlices + 1;
    int numIndices = numSlices * 3;
    float angleStep = (2.0f * ES_PI) / ((float) numSlices);;
    
    // Allocate memory for buffers
    if (vertices != NULL)
        *vertices = (GLfloat *)malloc (sizeof(GLfloat) * 3 * numVertices);
    
    if (normals != NULL)
        *normals = (GLfloat *)malloc (sizeof(GLfloat) * 3 * numVertices);
    
    if (texCoords != NULL)
        *texCoords = (GLfloat *)malloc (sizeof(GLfloat) * 2 * numVertices);
    
    if (indices != NULL)
        *indices = (GLushort*)malloc (sizeof(GLushort) * numIndices);
    
    for(short i = 0 ; i <= numSlices; i++) {
        //顶点坐标
        int vertex = i * 3;
        if(vertices) {
            if(i == 0) {
                (*vertices)[vertex + 0] = 0;
                (*vertices)[vertex + 1] = 0;
                (*vertices)[vertex + 2] = 0;
            }
            else {
                (*vertices)[vertex + 0] = cosf(angleStep*i)*R;
                (*vertices)[vertex + 1] = sinf(angleStep*i)*R;
                (*vertices)[vertex + 2] = 0;
            }
        }
        
        //顶点索引
        if(indices) {
            if(i < numSlices) {
                (*indices)[vertex+0] = 0;
                (*indices)[vertex+1] = i+1;
                if(i == (numSlices-1)) {
                    (*indices)[vertex+2] = 1;
                }
                else {
                    (*indices)[vertex+2] = i+2;
                }
            }
        }
        //纹理坐标
        if(texCoords) {
            int texIndex = i * 2;
            if(i == 0) {
                (*texCoords)[texIndex+0] = 0.5;
                (*texCoords)[texIndex+1] = 0.5;
            }
            else {
                (*texCoords)[texIndex+0] = (1+cosf(angleStep*i))/2;
                (*texCoords)[texIndex+1] = (1+sinf(angleStep*i))/2;
            }
        }
    }
    
    return numIndices;
}

//
/// \brief Generates geometry for a sphere.  Allocates memory for the vertex data and stores
///        the results in the arrays.  Generate index list for a TRIANGLE_STRIP
/// \param numSlices The number of slices in the sphere
/// \param vertices If not NULL, will contain array of float3 positions
/// \param normals If not NULL, will contain array of float3 normals
/// \param texCoords If not NULL, will contain array of float2 texCoords
/// \param indices If not NULL, will contain the array of indices for the triangle strip
/// \return The number of indices required for rendering the buffers (the number of indices stored in the indices array
///         if it is not NULL) as a GL_TRIANGLE_STRIP
//
int GenSphere (int numSlices, float radius,
                 GLfloat **vertices, GLfloat **normals,
                 GLfloat **texCoords, GLushort **indices,
                 int *numVertices_out)
{
    int numParallels = numSlices / 2;
    int numVertices = (numParallels + 1) * (numSlices + 1);
    int numIndices = numParallels * numSlices * 6;
    float angleStep = (2.0f * ES_PI) / ((float) numSlices);
    
    // Allocate memory for buffers
    if (vertices != NULL)
        *vertices = (GLfloat *)malloc(sizeof(GLfloat) * 3 * numVertices);
    
    if (normals != NULL)
        *normals = (GLfloat *)malloc(sizeof(GLfloat) * 3 * numVertices);
    
    if (texCoords != NULL)
        *texCoords = (GLfloat *)malloc(sizeof(GLfloat) * 2 * numVertices);
    
    if (indices != NULL)
        *indices = (GLushort *)malloc(sizeof(GLushort) * numIndices);
    
    for (int i = 0; i < numParallels + 1; i++) {
        for (int j = 0; j < numSlices + 1; j++) {
            int vertex = (i * (numSlices + 1) + j) * 3;
            
            if (vertices) {
                (*vertices)[vertex + 0] = radius * sinf(angleStep * (float)i) *
                sinf(angleStep * (float)j);
                (*vertices)[vertex + 1] = radius * cosf(angleStep * (float)i);
                (*vertices)[vertex + 2] = radius * sinf(angleStep * (float)i) *
                cosf(angleStep * (float)j);
            }
            
            if (normals) {
                (*normals)[vertex + 0] = (*vertices)[vertex + 0] / radius;
                (*normals)[vertex + 1] = (*vertices)[vertex + 1] / radius;
                (*normals)[vertex + 2] = (*vertices)[vertex + 2] / radius;
            }
            
            if (texCoords) {
                int texIndex = (i * (numSlices + 1) + j) * 2;
                (*texCoords)[texIndex + 0] = (float) j / (float) numSlices;
                (*texCoords)[texIndex + 1] = 1.0f - ((float) i / (float) (numParallels));
            }
        }
    }
    
    // Generate the indices
    if (indices != NULL) {
        GLushort *indexBuf = (*indices);
        for (short i = 0; i < numParallels ; i++) {
            for (short j = 0; j < numSlices; j++) {
                *indexBuf++  = i * (numSlices + 1) + j;
                *indexBuf++ = (i + 1) * (numSlices + 1) + j;
                *indexBuf++ = (i + 1) * (numSlices + 1) + (j + 1);
                
                *indexBuf++ = i * (numSlices + 1) + j;
                *indexBuf++ = (i + 1) * (numSlices + 1) + (j + 1);
                *indexBuf++ = i * (numSlices + 1) + (j + 1);
            }
        }
    }
    
    if(numVertices_out) {
        *numVertices_out = numVertices;
    }
    
    return numIndices;
}
