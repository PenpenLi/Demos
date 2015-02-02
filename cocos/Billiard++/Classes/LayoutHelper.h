/************************************************************************/
/* LayoutHelper.h                                                       */
/************************************************************************/
#ifndef GAME_LAYOUTHELPER_H
#define GAME_LAYOUTHELPER_H
#include "cocos2d.h"

/**
 * @class LayoutHelper
 */
class LayoutHelper
{
public:
    static void layoutWithDesignResolution(float width, float height);
    static cocos2d::Rect getVisibleRect();
    static void addLayerToScene(cocos2d::Scene *scene, cocos2d::Layer *layer);
private:
    static cocos2d::Size _designSize;
};

#endif
