//
//  Game.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#include "Game.h"
#include "Ball.h"
#include "cocos2d.h"

USING_NS_CC;

Game::Game() {
    for (int i=0; i<16; ++i) {
        balls.push_back(new Ball(i));
    }
    
    reset();
}

Game::~Game() {
    for (auto ball : balls) {
        delete ball;
    }
    balls.clear();
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
    }
}
