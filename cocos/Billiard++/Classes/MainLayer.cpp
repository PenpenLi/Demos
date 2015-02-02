//
//  MainLayer.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#include "MainLayer.h"
#include "GameLayer.h"
#include "GameManager.h"

USING_NS_CC;

Scene* MainLayer::createScene() {
    auto scene = Scene::create();
    scene->addChild(MainLayer::create());
    return scene;
}

bool MainLayer::init() {
    if (!Layer::init()) return false;
    
    this->addChild(LayerColor::create(Color4B(38, 120, 29, 255)));
    
    this->addChild(GameLayer::create());
    
    return true;
}

void MainLayer::onEnter() {
    Layer::onEnter();
    
    GM.startGame();
}

void MainLayer::onExit() {
    Layer::onExit();
}
