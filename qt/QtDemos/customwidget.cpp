#include "customwidget.h"
#include <QPainter>

CustomWidget::CustomWidget(QWidget *parent) :
    QWidget(parent)
{
    setAttribute(Qt::WA_TranslucentBackground, true);
    hide();
}

void CustomWidget::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    p.setCompositionMode(QPainter::CompositionMode_Clear);
    p.fillRect(this->rect(), Qt::SolidPattern);
    p.setCompositionMode(QPainter::CompositionMode_SourceOver);
    p.fillRect(this->rect(), QColor(0, 0, 0, 128));
}
