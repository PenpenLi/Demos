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
    LOGT("CocosWidget()");
//    getApp().applicationDidFinishLaunching();
//    connect(&_cocosTimer, SIGNAL(timeout()),
//            this, SLOT(cocosLoop()));
//    _cocosTimer.start(DEFAULT_FPS * 1000);
//    AppDelegate app;
//    Application::getInstance()->run();
    _cocosThread
}

CocosWidget::~CocosWidget()
{
    LOGT("~CocosWidget()");
}

void CocosWidget::cocosLoop()
{
    LOGT("cocosLoop()");
    static bool init = false;
    if (!init) {
        getApp().applicationDidFinishLaunching();
        init = true;
    }
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();
    glview->retain();
    director->mainLoop();
    glview->pollEvents();
    glview->release();
}
