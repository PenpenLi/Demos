#include "LayoutHelper.h"

USING_NS_CC;

#define UNIFORM_SCALE

Size LayoutHelper::_designSize = Size::ZERO;

void LayoutHelper::layoutWithDesignResolution(float width, float height) {
    _designSize.setSize(width, height);
    auto glView = Director::getInstance()->getOpenGLView();
#ifdef UNIFORM_SCALE
    auto screenSize = glView->getFrameSize();
    float scaleX = screenSize.width / width;
    float scaleY = screenSize.height / height;
    if (scaleX > scaleY) {
        glView->setDesignResolutionSize(width, height, ResolutionPolicy::FIXED_HEIGHT);
    } else {
        glView->setDesignResolutionSize(width, height, ResolutionPolicy::FIXED_WIDTH);
    }
#else
    glView->setDesignResolutionSize(width, height, ResolutionPolicy::EXACT_FIT);
#endif
}

Rect LayoutHelper::getVisibleRect() {
    auto director = Director::getInstance();
    auto screenSize = director->getWinSize();
    Rect visiableRect;
#ifdef UNIFORM_SCALE
    auto glView = director->getOpenGLView();
    switch (glView->getResolutionPolicy())
    {
        case ResolutionPolicy::FIXED_HEIGHT:
            visiableRect.origin = Vec2(fabs(screenSize.width-_designSize.width)/2, 0);
            visiableRect.size = Size(screenSize.width-fabs(screenSize.width-_designSize.width), screenSize.height);
            break;
        case ResolutionPolicy::FIXED_WIDTH:
            visiableRect.origin = Vec2(0, fabs(screenSize.height-_designSize.height)/2);
            visiableRect.size = Size(screenSize.width, screenSize.height-fabs(screenSize.height-_designSize.height));
            break;
        default:
            break;
    }
#else
    visiableRect.origin = director->getVisibleOrigin();
    visiableRect.size = director->getVisibleSize();
#endif
    return visiableRect;
}

void LayoutHelper::addLayerToScene(cocos2d::Scene *scene, cocos2d::Layer *layer) {
#ifdef UNIFORM_SCALE
    auto director = Director::getInstance();
    auto winSize = director->getWinSize();
    auto visiableOrigin = getVisibleRect().origin;
    auto visiableSize = getVisibleRect().size;
    auto bgLayer = Layer::create();
    auto bgImage = Sprite::create("background.png");
    bgImage->setPosition(winSize.width/2, winSize.height/2);
    bgLayer->addChild(bgImage, 0);
    scene->addChild(bgLayer, 0);
    
    layer->setPosition(visiableOrigin);
    layer->setContentSize(visiableSize);
#endif // UNIFORM_SCALE
    
    scene->addChild(layer);
}