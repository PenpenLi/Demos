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

#define GM (GameManager::getInstance())

class Ball;
class Game;

class GameManager {
public:
    static inline GameManager& getInstance() {
        static GameManager mgr;
        return mgr;
    }
    
    bool init();
    
    void deinit();
    
    void createMainScene();
    
    void startGame();
    void stopGame();
    void restartGame();
    void reset();
    
    void update(float dt);
    
    Game *game;
protected:
    GameManager();
    ~GameManager();
    
private:
    cocos2d::Director *_director;
    cocos2d::Scheduler *_scheduler;
    bool _init;
    
};

#endif /* defined(__Billiard____GameManager__) */
