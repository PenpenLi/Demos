//
//  GameManager.h
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#ifndef __Billiard____GameManager__
#define __Billiard____GameManager__

#include <vector>
#include "cocos2d.h"
#include "Game.h"

#define GM (GameManager::getInstance())

class Ball;

class GameManager {
public:
    static inline GameManager& getInstance() {
        static GameManager mgr;
        return mgr;
    }
    
    bool init();
    
    void deinit();
    
    void go();
    
    Game game;
protected:
    GameManager();
    ~GameManager();
    
private:
    cocos2d::Director *_director;
};

#endif /* defined(__Billiard____GameManager__) */
