//
//  Ball.h
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#ifndef __Billiard____Ball__
#define __Billiard____Ball__
#include "cocos2d.h"

using cocos2d::Vec2;
using cocos2d::Quaternion;

class Ball {
public:
    static const float R;
    static const float D;
    
    explicit Ball(int id_);
    ~Ball();
    
    void reset();
    
    int ballId;
    bool isMoving;
    Vec2 p;
    Vec2 v;
    Quaternion w;
};

#endif /* defined(__Billiard____Ball__) */
