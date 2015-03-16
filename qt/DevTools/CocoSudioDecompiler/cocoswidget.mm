#include "cocoswidget.h"

#include <AppKit/AppKit.h>

#include <QResizeEvent>
#include <QMoveEvent>
#include <QCloseEvent>

#include "cocosrunner.h"

#include "cocos2d.h"
#include "glfw3.h"
#include "glfw3native.h"

#define LOG_TAG "CocosWidget"
#include "logger.h"

using namespace cocos2d;

CocosWidget::CocosWidget(QWidget *parent)
: QWidget(parent)
{
    _runner = new CocosRunner;
    connect(_runner, SIGNAL(cocosReady()), this, SLOT(onCocosReady()));
    _runner->Run();
}

CocosWidget::~CocosWidget()
{
    _runner->Stop();
    delete _runner;
}

void CocosWidget::resizeEvent(QResizeEvent *event)
{
    QWidget::resizeEvent(event);
    auto size = event->size();
    LOGT("resizeEvent: {" << size.width() << ", " << size.height() << "}");
}

void CocosWidget::moveEvent(QMoveEvent *event)
{
    QWidget::moveEvent(event);
    auto point = event->pos();
    LOGT("moveEvent: {" << point.x() << ", " << point.y() << "}");
}

void CocosWidget::closeEvent(QCloseEvent *event)
{
    LOGT("closeEvent");
    QWidget::closeEvent(event);
}

void CocosWidget::onCocosReady()
{
    LOGT("onCocosReady()");
    auto glview = Director::getInstance()->getOpenGLView();
    if (glview) {
        NSWindow *cocosWin = glview->getCocoaWindow();
        NSView *widgetWin = (NSView*)this->winId();
        [cocosWin setStyleMask:NSBorderlessWindowMask];
        [widgetWin.window addChildWindow:cocosWin ordered:NSWindowAbove];
    }
}
