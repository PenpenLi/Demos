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

USING_NS_CC;

GameManager::GameManager() {
    
}

GameManager::~GameManager() {
    
}

bool GameManager::init() {
    
    _director = Director::getInstance();
    if (!_director) return false;
    _director->retain();
    
    return true;
}

void GameManager::deinit() {
    CC_SAFE_RELEASE_NULL(_director);
}

void GameManager::go() {
    if (!_director) return;
    
    _director->runWithScene(MainLayer::createScene());
}
