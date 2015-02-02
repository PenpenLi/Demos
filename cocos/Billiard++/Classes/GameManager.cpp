//
//  GameManager.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#include "GameManager.h"

#include <cstdlib>

#include "MainLayer.h"
#include "Game.h"

USING_NS_CC;

GameManager::GameManager() : _director(nullptr), _scheduler(nullptr), _init(false) {
    
}

GameManager::~GameManager() {
    if (_init) deinit();
}

bool GameManager::init() {
    do {
        _director = Director::getInstance();
        CCASSERT(_director, "Director is null!");
        if (!_director) break;
        _director->retain();
        
        _scheduler = _director->getScheduler();
        
        game = new Game;
        CCASSERT(game, "Game is null!");
        if (!game || !game->init()) break;
        
        _init = true;
    } while (0);
    
    if (!_init) deinit();
    
    return _init;
}

void GameManager::deinit() {
    CC_SAFE_DELETE(game);
    CC_SAFE_RELEASE_NULL(_director);
}

void GameManager::createMainScene() {
    if (!_init) return;
    _director->runWithScene(MainLayer::createScene());
}

void GameManager::startGame() {
    if (!_init) return;
    _scheduler->scheduleUpdate(this, 0, false);
}

void GameManager::stopGame() {
    if (!_init) return;
    _scheduler->unscheduleUpdate(this);
}

void GameManager::restartGame() {
    stopGame();
    reset();
    startGame();
}

void GameManager::reset() {
    game->reset();
}

void GameManager::update(float dt) {
    // logic
    game->update(dt);
    // ui
}
