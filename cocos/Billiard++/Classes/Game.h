//
//  Game.h
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#ifndef __Billiard____Game__
#define __Billiard____Game__

#include <vector>

class Ball;

class Game {
public:
    Game();
    ~Game();
    
    void reset();
    
    std::vector<Ball*> balls;
};

#endif /* defined(__Billiard____Game__) */
