//
//  GameLayer.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#include "GameLayer.h"
#include "Ball.h"
#include "GameManager.h"
#include "GLHelper.h"
#include "Game.h"

USING_NS_CC;

bool GameLayer::init() {
    if (!Layer::init()) return false;
    // shaders
    _ballShaderProgram = GLProgramCache::getInstance()->getGLProgram(GLProgram::SHADER_NAME_POSITION_TEXTURE);
    CCASSERT(_ballShaderProgram, "_ballShaderProgram is null!");
    if (!_ballShaderProgram) return false;
    _ballShaderProgram->retain();
    
    // vertexes
    _sphereIndexCount = GenSphere(20, Ball::R,
                                  &_sphereVertexData, nullptr,
                                  &_sphereTexCoordData, &_sphereIndexData,
                                  nullptr);
    _lightIndexCount = GenCircle(10, Ball::R+5, &_lightVertexData, nullptr,
                                 &_lightTexCoordData, &_lightIndexData);
    
    // textures
    auto cache = Director::getInstance()->getTextureCache();
    for (int i=0; i<16; ++i) {
        char cTex[32] = {0};
        sprintf(cTex, "res/BallTex/%03d.png", i);
        Texture2D *texture = cache->addImage(cTex);
        CCASSERT(texture, "ball texture is null!");
        if (!texture) return false;
        _ballTextures.pushBack(texture);
    }
    auto light = cache->addImage("res/BallTex/light.png");
    CCASSERT(light, "light texture is null!");
    if (!light) return false;
    _ballTextures.pushBack(light);
    
    return true;
}

void GameLayer::onEnter() {
    Layer::onEnter();
    
}

void GameLayer::onExit() {
    
    CC_SAFE_RELEASE_NULL(_ballShaderProgram);
    CC_SAFE_DELETE(_sphereIndexData);
    CC_SAFE_DELETE(_sphereTexCoordData);
    CC_SAFE_DELETE(_sphereVertexData);
    CC_SAFE_DELETE(_lightIndexData);
    CC_SAFE_DELETE(_lightTexCoordData);
    CC_SAFE_DELETE(_lightVertexData);
    _ballTextures.clear();
    
    Layer::onExit();
}

void GameLayer::onDraw(const Mat4& transform, uint32_t flags)
{
    if (!_ballShaderProgram) return;
    
    auto director = Director::getInstance();
    auto size = director->getWinSize();
    
    // draw
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    
    auto& balls = GM.game->balls;
    for (auto i=0; i<balls.size(); ++i) {
        auto ball = balls[i];
        auto& p = ball->p;
        auto& w = ball->w;
        auto& v = ball->v;
        
        {
            //---------------------------------------------------------------------------
            // draw ball, push
            director->pushMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_MODELVIEW);
            director->loadIdentityMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_MODELVIEW);
            director->pushMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
            director->loadIdentityMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
            
            // 变换
            Mat4 translateMat;
            Mat4::createTranslation(p.x, p.y, 0, &translateMat);     //移动
            Mat4 rotateMat;
            Mat4::createRotation(w, &rotateMat);
            Mat4 orthoMatrix;
            Mat4::createOrthographicOffCenter(0, size.width, 0, size.height, -1024, 1024, &orthoMatrix);
            director->multiplyMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_MODELVIEW, translateMat);
            director->multiplyMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_MODELVIEW, rotateMat);
            director->multiplyMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION, orthoMatrix);
            
            // use shader
            _ballShaderProgram->use();
            _ballShaderProgram->setUniformsForBuiltins();
            
            // 纹理
            GL::bindTexture2D(_ballTextures.at(i)->getName());
            // 顶点数据
            GL::enableVertexAttribs(GL::VERTEX_ATTRIB_FLAG_TEX_COORD | GL::VERTEX_ATTRIB_FLAG_POSITION);
            glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_POSITION, 3,
                                  GL_FLOAT, GL_FALSE, 0, _sphereVertexData);
            glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_TEX_COORD, 2,
                                  GL_FLOAT, GL_FALSE, 0, _sphereTexCoordData);
            // 画
            glDrawElements(GL_TRIANGLES, _sphereIndexCount, GL_UNSIGNED_SHORT, _sphereIndexData);
            CC_INCREMENT_GL_DRAWN_BATCHES_AND_VERTICES(1, _sphereIndexCount);
            
            // end draw ball, pop
            director->popMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
            director->popMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_MODELVIEW);
        }
        {
            //---------------------------------------------------------------------------
            // draw light
            director->pushMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_MODELVIEW);
            director->loadIdentityMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_MODELVIEW);
            director->pushMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
            director->loadIdentityMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
            
            Mat4 translateMat;
            Mat4::createTranslation(p.x, p.y, 0, &translateMat);     //移动
            Mat4 orthoMatrix;
            Mat4::createOrthographicOffCenter(0, size.width, 0, size.height, -1024, 1024, &orthoMatrix);
            director->multiplyMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_MODELVIEW, translateMat);
            director->multiplyMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION, orthoMatrix);
            
            
            _ballShaderProgram->use();
            _ballShaderProgram->setUniformsForBuiltins();
            
            GL::bindTexture2D(_ballTextures.back()->getName());
            GL::enableVertexAttribs(GL::VERTEX_ATTRIB_FLAG_TEX_COORD | GL::VERTEX_ATTRIB_FLAG_POSITION);
            
            glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_POSITION, 3,
                                  GL_FLOAT, GL_FALSE, 0, _lightVertexData);
            glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_TEX_COORD, 2,
                                  GL_FLOAT, GL_FALSE, 0, _lightTexCoordData);
            glDrawElements(GL_TRIANGLES, _lightIndexCount, GL_UNSIGNED_SHORT, _lightIndexData);
            CC_INCREMENT_GL_DRAWN_BATCHES_AND_VERTICES(1, _lightIndexCount);
            
            director->popMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
            director->popMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_MODELVIEW);
        }
    }
    
    glDisable(GL_CULL_FACE);
}

void GameLayer::visit(Renderer *renderer, const Mat4& parentTransform, uint32_t parentFlags)
{
    Layer::visit(renderer, parentTransform, parentFlags);
    _command.init(_globalZOrder);
    _command.func = CC_CALLBACK_0(GameLayer::onDraw, this, parentTransform, parentFlags);
    renderer->addCommand(&_command);
}
