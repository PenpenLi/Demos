//
//  Math.h
//  Billiard++
//
//  Created by Xiaobin Li on 1/31/15.
//
//

#ifndef __Billiard____Math__
#define __Billiard____Math__

#include "cocos2d.h"

using cocos2d::Vec2;
using cocos2d::Quaternion;
using cocos2d::Vec3;
using cocos2d::Rect;

typedef struct Line {
    Line() : a(Vec2::ZERO), b(Vec2::ZERO)  {}
    Line(const Vec2& aa, const Vec2& bb) : a(aa), b(bb) {}
    
    Vec2 dir() {
        auto dir(b-a);
        return dir.getNormalized();
    }
    
    Vec2 a;
    Vec2 b;
} Line_t;

#endif /* defined(__Billiard____Math__) */
