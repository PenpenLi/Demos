//
//  Border.h
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#ifndef __Billiard____Border__
#define __Billiard____Border__
#include "GameMath.h"

class Border {
public:
    // todo: types
    enum class Type {
        LEFT = 0,
        RIGHT,
        TOP,
        BOTTOM,
    };
    
    explicit Border(int id_);
    ~Border();
    
    inline int getBorderId() const { return _borderId; }
    inline Type getType() const { return _type; }
    inline const Line& getLine() const { return _line; }
    inline const Vec2& normal() const { return _normal; }
    
    inline Line& getLine() { return getLine(); }
    
    float getCoord();
    
private:
    int _borderId;
    Type _type;
    Line _line;
    Vec2 _normal;
};

#endif /* defined(__Billiard____Border__) */
