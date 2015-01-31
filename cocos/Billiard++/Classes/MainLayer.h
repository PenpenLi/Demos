//
//  MainLayer.h
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#ifndef __Billiard____MainLayer__
#define __Billiard____MainLayer__

#include "cocos2d.h"

/**
 * @class MainLayer
 * @brief main vc
 */
class MainLayer: public cocos2d::Layer {
public:
    
    static cocos2d::Scene* createScene();
    
    /// init
    bool init() override;
    void onEnter() override;
    void onExit() override;
    
    /// static create
    CREATE_FUNC(MainLayer);
};

#endif /* defined(__Billiard____MainLayer__) */
