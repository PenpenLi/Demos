#include "cocosrunner.h"
#include <QThread>
#include <QApplication>

#include "cocos2d.h"
#include "AppDelegate.h"

#define LOG_TAG "CocosRunner"
#include "logger.h"

using namespace cocos2d;

static const float DEFAULT_FPS = 1/60.f;
static const float ANIMATION_INTERVAL = DEFAULT_FPS * 1000;

static long getCurrentMillSecond()
{
    long lLastTime = 0;
    struct timeval stCurrentTime;

    gettimeofday(&stCurrentTime,NULL);
    lLastTime = stCurrentTime.tv_sec*1000+stCurrentTime.tv_usec*0.001; //millseconds
    return lLastTime;
}

CocosRunner::CocosRunner(QObject *parent) : QObject(parent)
{
    this->moveToThread(&_cocosThread);
    connect(&_cocosThread, SIGNAL(started()), this, SLOT(Started()));
    connect(&_cocosThread, SIGNAL(finished()), this, SLOT(Stopped()));
}

CocosRunner::~CocosRunner()
{
    if (_cocosThread.isRunning()) {
        Director::getInstance()->end();
        _cocosThread.wait();
    }
}

void CocosRunner::Started()
{
    LOGT("Started ...");
    static AppDelegate app;
    if (!app.applicationDidFinishLaunching()) _cocosThread.quit();

    emit cocosReady();

    long lastTime = 0L;
    long curTime = 0L;

    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();

    // Retain glview to avoid glview being released in the while loop
    glview->retain();

    while (!glview->windowShouldClose())
    {
        lastTime = getCurrentMillSecond();

        director->mainLoop();
        glview->pollEvents();

        curTime = getCurrentMillSecond();
        if (curTime - lastTime < ANIMATION_INTERVAL)
        {
            QThread::usleep(static_cast<useconds_t>((ANIMATION_INTERVAL - curTime + lastTime)*1000));
        }
    }

    /* Only work on Desktop
        *  Director::mainLoop is really one frame logic
        *  when we want to close the window, we should call Director::end();
        *  then call Director::mainLoop to do release of internal resources
        */
    if (glview->isOpenGLReady())
    {
        director->end();
        director->mainLoop();
    }

    glview->release();
    LOGT("Finish running.");
    _cocosThread.quit();
}

void CocosRunner::Stopped()
{
    LOGT("Stopped.");
}

void CocosRunner::Run()
{
    LOGT("Run ...");
    _cocosThread.start();
    LOGT("cocos thread started ...");
}

void CocosRunner::Stop()
{
    LOGT("end director ...");
    Director::getInstance()->end();
    LOGT("wait for cocos thread ...");
    _cocosThread.wait();
    LOGT("OK.");
}
