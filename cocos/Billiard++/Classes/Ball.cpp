//
//  Ball.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#include "Ball.h"
#include "State.h"
#include "Config.h"

USING_NS_CC;

const float Ball::R = BALL_R;
const float Ball::D = 2*BALL_R;
const float Ball::M = 1.f;


bool isMoving;
bool inGame;
bool inHole;
Ball::Ball(int id_)
: ballId(id_), isMoving(false), inGame(true)
, inHole(false), _state(nullptr) {
    reset();
}

Ball::~Ball() {
    CC_SAFE_DELETE(_state);
}

void Ball::reset() {
    isMoving = false;
    inGame = true;
    inHole = false;
    p = Vec2::ZERO;
    v = Vec2::ZERO;
    auto r = Vec3(CCRANDOM_0_1(), CCRANDOM_0_1(), CCRANDOM_0_1());
    w = Quaternion(r, CCRANDOM_0_1()*M_PI*2);
    w.normalize();
    paths.clear();
}

void Ball::update(float dt) {
    if (_state) {
        _state->Exec(dt);
    }
}

void Ball::setState(State *state) {
    if (_state != state) {
        if (_state) _state->Exit();
        _state = state;
        if (_state) _state->Enter();
    }
}
