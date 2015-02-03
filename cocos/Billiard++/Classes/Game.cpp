//
//  Game.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#include "Game.h"
#include "Ball.h"
#include "Hole.h"
#include "Border.h"
#include "cocos2d.h"
#include "RollingState.h"

#define TEST 1

USING_NS_CC;

Game::Game() {
}

Game::~Game() {
    for (auto ball : balls) {
        delete ball;
    }
    balls.clear();
    for (auto border : borders) {
        delete border;
    }
    borders.clear();
    for (auto hole : holes) {
        delete hole;
    }
    holes.clear();
}

void Game::reset() {
    std::srand(time(nullptr));
    auto size = Director::getInstance()->getWinSize();
    CCLOG("WinSize: {%.2f, %.2f}", size.width, size.height);
    for (auto ball : balls) {
        ball->reset();
        ball->p = Vec2(CCRANDOM_0_1()*(size.width-Ball::D)+Ball::R,
                       CCRANDOM_0_1()*(size.height-Ball::D)+Ball::R);
        CCLOG("ball%d: {%.2f, %.2f}", ball->ballId, ball->p.x, ball->p.y);
#if TEST
        auto v = Vec2(CCRANDOM_0_1(), CCRANDOM_0_1());
        v.normalize();
        v.scale(CCRANDOM_0_1()*5+5);
        ball->v = v;
        ball->isMoving = true;
        ball->setState(new RollingState(ball));
#endif
    }
}

bool Game::init() {
    balls.clear();
    borders.clear();
    holes.clear();
    for (int i=0; i<16; ++i) {
        auto ball = new Ball(i);
        CCASSERT(ball, "new Ball error!");
        balls.push_back(ball);
    }
    // todo: borders and holes
    for (int i=0; i<4; ++i) {
        auto border = new Border(i);
        CCASSERT(border, "new Border error!");
        borders.push_back(border);
    }
    
    reset();
    return true;
}

void Game::update(float dt) {
    for (auto ball : balls) {
        ball->update(dt);
    }
    
    // check wall collision
    for (auto ball : balls) {
        auto& v = ball->v;
        auto& p = ball->p;
        for (auto border : borders) {
            auto& n = border->normal();
            if (v.dot(n)<0.f) {
                float coord = border->getCoord();
                switch (border->getType()) {
                    case Border::Type::LEFT:
                        if (p.x < coord) {
                            v.x = -v.x;
                        }
                        break;
                    case Border::Type::RIGHT:
                        if (p.x > coord) {
                            v.x = -v.x;
                        }
                        break;
                    case Border::Type::TOP:
                        if (p.y > coord) {
                            v.y = -v.y;
                        }
                        break;
                    case Border::Type::BOTTOM:
                        if (p.y < coord) {
                            v.y = -v.y;
                        }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
    // check ball collision
}
