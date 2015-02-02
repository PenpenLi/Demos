//
//  Ball.h
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#ifndef __Billiard____Ball__
#define __Billiard____Ball__

#include <vector>
#include "cocos2d.h"

using cocos2d::Vec2;
using cocos2d::Quaternion;
using cocos2d::Vec3;

class State;

class Ball {
public:
    static const float R;
    static const float D;
    static const float M;
    
    explicit Ball(int id_);
    ~Ball();
    
    void reset();
    
    void setState(State *state);
    
    void update(float dt);
    
    Vec2 normal() {
        Vec2 n(-v.y, v.x);
        return n.getNormalized();
    }
    
    Vec2 dir() {
        return v.getNormalized();
    }
    
    int ballId;
    bool isMoving;
    bool inGame;
    bool inHole;
    
    Vec2 p;
    Vec2 v;
    Quaternion w;
    std::vector<Vec2> paths;
    
private:
    State *_state;
};

#endif /* defined(__Billiard____Ball__) */
