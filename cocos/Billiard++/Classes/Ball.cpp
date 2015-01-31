//
//  Ball.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#include "Ball.h"

USING_NS_CC;

const float Ball::R = 20.f;
const float Ball::D = 2*Ball::R;

Ball::Ball(int id_) : ballId(id_), isMoving(false) {
    reset();
}

Ball::~Ball() {
    
}

void Ball::reset() {
    isMoving = false;
    p = Vec2::ZERO;
    v = Vec2::ZERO;
    auto r = Vec3(CCRANDOM_0_1(), CCRANDOM_0_1(), CCRANDOM_0_1());
    w = Quaternion(r, CCRANDOM_0_1()*M_PI*2);
    w.normalize();
}
