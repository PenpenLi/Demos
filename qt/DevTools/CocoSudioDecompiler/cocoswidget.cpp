#include "cocoswidget.h"

#define LOG_TAG "CocosWidget"
#include "logger.h"

CocosWidget::CocosWidget(QWidget *parent) :
    QWidget(parent)
{
    connect(&_cocosTimer, SIGNAL(timeout()),
            this, SLOT(cocosLoop()));
    _cocosTimer.start(1 / 60.f * 1000);
}

CocosWidget::~CocosWidget()
{
    LOGT("~CocosWidget()");
}

void CocosWidget::cocosLoop()
{
//    LOGT("cocosLoop ...");
}
