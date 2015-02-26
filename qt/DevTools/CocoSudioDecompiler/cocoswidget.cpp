#include "cocoswidget.h"
#include "cocos2d.h"
#include "AppDelegate.h"

USING_NS_CC;

#define LOG_TAG "CocosWidget"
#include "logger.h"

static AppDelegate& getApp() {
    static AppDelegate app;
    return app;
}

static const float DEFAULT_FPS = 1/60.f;

CocosWidget::CocosWidget(QWidget *parent) :
    QWidget(parent)
{
    getApp().run();

    connect(&_cocosTimer, SIGNAL(timeout()),
            this, SLOT(cocosLoop()));
    _cocosTimer.start(DEFAULT_FPS * 1000);
}

CocosWidget::~CocosWidget()
{
    LOGT("~CocosWidget()");
}

void CocosWidget::cocosLoop()
{
//    LOGT("cocosLoop ...");
    auto director = Director::getInstance();
    director->mainLoop();
}
