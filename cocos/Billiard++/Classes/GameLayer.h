//
//  GameLayer.h
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#ifndef __Billiard____GameLayer__
#define __Billiard____GameLayer__

#include "cocos2d.h"

/**
 * @class GameLayer
 * @brief game layer
 */
class GameLayer: public cocos2d::Layer {
public:
    
    /// init
    bool init() override;
    void onEnter() override;
    void onExit() override;
    
    
    void onDraw(const cocos2d::Mat4& transform, uint32_t flags);
    void visit(cocos2d::Renderer *renderer, const cocos2d::Mat4& parentTransform, uint32_t parentFlags) override;
    
    /// static create
    CREATE_FUNC(GameLayer);
    
private:
    cocos2d::CustomCommand _command;
    cocos2d::Vector<cocos2d::Texture2D *> _ballTextures;
    
    // sphere
    cocos2d::GLProgram *_ballShaderProgram;
    GLfloat *_sphereVertexData;
    GLfloat *_sphereTexCoordData;
    GLushort *_sphereIndexData;
    int _sphereIndexCount;
    
    // light
    GLfloat *_lightVertexData;
    GLfloat *_lightTexCoordData;
    GLushort *_lightIndexData;
    int _lightIndexCount;
};

#endif /* defined(__Billiard____GameLayer__) */
