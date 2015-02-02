//
//  RollingState.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 2/2/15.
//
//

#include "RollingState.h"
#include "Ball.h"

void RollingState::Exec(float dt) {
    auto& p = _ball->p;
    auto& v = _ball->v;
    p += v;
    auto& w = _ball->w;
    
    if (_ball->isMoving) {
        auto dis = v.length();
        Quaternion nw(Vec3(-v.y, v.x, 0), dis/Ball::R);
        nw.normalize();
        nw.multiply(w);
        _ball->w = nw;
    }
}

void RollingState::Enter() {
    
}

void RollingState::Exit() {
    
}
