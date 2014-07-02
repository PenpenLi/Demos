#include "customdialog.h"
#include <QPainter>
#include <QPalette>
#include <QEvent>
#include <QDebug>

CustomDialog::CustomDialog(QWidget *parent) :
    QDialog(parent, Qt::FramelessWindowHint | Qt::CustomizeWindowHint)
{
    setAttribute(Qt::WA_TranslucentBackground, true);
//    setWindowModality(Qt::ApplicationModal);
//    setModal(true);
//    setwind
//    hide();
    if (parent)
    {
        parent->installEventFilter(this);
    }
}

void CustomDialog::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    p.setCompositionMode(QPainter::CompositionMode_Clear);
    p.fillRect(this->rect(), Qt::SolidPattern);
    p.setCompositionMode(QPainter::CompositionMode_SourceOver);
    p.fillRect(this->rect(), QColor(0, 0, 0, 128));
}

void CustomDialog::showEvent(QShowEvent *e)
{
    QDialog::showEvent(e);
}

void CustomDialog::hideEvent(QHideEvent *e)
{
    QDialog::hideEvent(e);
}

bool CustomDialog::eventFilter(QObject *o, QEvent *e)
{
    if (o == parent())
    {
//        raise();
//        switch (e->type())
//        {
//        case QEvent::WindowActivate:
//        case QEvent::WindowUnblocked:
//            qDebug() << "parent WindowActivate";
//            raise();
//            break;
//        case QEvent::Move:
//            qDebug() << "parent Move";
//            raise();
//            break;
//        case QEvent::MouseButtonPress:
//        case QEvent::MouseButtonDblClick:
//        case QEvent::MouseButtonRelease:
//            qDebug() << "parent Mouse event";
//            raise();
//            break;
//        default:
//            break;
//        }
    }
    return false;
}

bool CustomDialog::event(QEvent *e)
{
//    switch (e->type())
//    {
//    case QEvent::WindowDeactivate:
//        qDebug() << "WindowDeactivate";
//        raise();
//        break;
//    case QEvent::ZOrderChange:
//        qDebug() << "ZOrderChange";
//        break;
//    default:
//        break;
//    }
    return QDialog::event(e);
}
