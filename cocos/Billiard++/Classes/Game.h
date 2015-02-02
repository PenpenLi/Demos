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
class Border;
class Hole;

class Game {
public:
    Game();
    ~Game();
    
    bool init();
    
    void reset();
    
    std::vector<Ball*>      balls;
    std::vector<Border*>    borders;
    std::vector<Hole*>      holes;
    
    void update(float dt);
};

#endif /* defined(__Billiard____Game__) */
