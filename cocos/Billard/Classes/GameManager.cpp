//
//  GameManager.cpp
//  Billard
//
//  Created by Xiaobin Li on 12/19/14.
//
//

#include "GameManager.h"

using namespace TQ;

static GameManagerPtr s_GameManager = nullptr;

GameManager::GameManager() {
    
}

GameManager::~GameManager() {
    
}

GameManagerPtr GameManager::getInstance() {
    if (!s_GameManager) {
        s_GameManager.reset(new GameManager);
    }
    return s_GameManager;
}

void GameManager::destroyInstance() {
    s_GameManager.reset(nullptr);
}
