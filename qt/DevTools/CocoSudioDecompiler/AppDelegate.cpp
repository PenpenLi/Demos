#include "AppDelegate.h"

#include <vector>
#include <string>

#include "qglviewimpl.h"
#include "platform/desktop/CCGLViewImpl-desktop.h"

#define LOG_TAG "AppDelegate"
#include "logger.h"

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate() {

}

AppDelegate::~AppDelegate() 
{
}

bool AppDelegate::applicationDidFinishLaunching() {
    // initialize director
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();
    if(!glview) {
        glview = GLViewImpl::create("Cpp Empty Test");
        LOGT("glview: " << glview);
        director->setOpenGLView(glview);
    }

    glview = director->getOpenGLView();
    LOGT("glview: " << glview);
	
    // turn on display FPS
    director->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 60);

    // run
    director->runWithScene(Scene::create());

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
    Director::getInstance()->stopAnimation();

    // if you use SimpleAudioEngine, it must be pause
    // SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
    Director::getInstance()->startAnimation();

    // if you use SimpleAudioEngine, it must resume here
    // SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}

//int AppDelegate::run() {
//    if(!applicationDidFinishLaunching()) {
//        return 1;
//    }
//    return 0;
//}
