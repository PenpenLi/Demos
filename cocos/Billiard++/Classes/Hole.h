//
//  Hole.h
//  Billiard++
//
//  Created by Xiaobin Li on 2/2/15.
//
//

#ifndef __Billiard____Hole__
#define __Billiard____Hole__

#include <vector>
#include "GameMath.h"

class Hole {
public:
    static const float R;
    static const float D;
    
    explicit Hole(int iid);
    ~Hole();
    
    int holeId;
    Vec2 p;
    std::vector<Vec2> aim;
};

#endif /* defined(__Billiard____Hole__) */
