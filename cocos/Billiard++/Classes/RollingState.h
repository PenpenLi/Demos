//
//  RollingState.h
//  Billiard++
//
//  Created by Xiaobin Li on 2/2/15.
//
//

#ifndef __Billiard____RollingState__
#define __Billiard____RollingState__

#include "State.h"

class Ball;

class RollingState : public State {
public:
    RollingState(Ball *ball) : _ball(ball) {}
    virtual ~RollingState() { _ball = nullptr; }
    
    virtual void Exec(float dt);
    virtual void Enter();
    virtual void Exit();
    
private:
    Ball *_ball;
};

#endif /* defined(__Billiard____RollingState__) */
