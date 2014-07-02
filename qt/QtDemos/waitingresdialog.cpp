#include "WaitingResDialog.h"
#include "ui_WaitingResDialog.h"
#include <QPainter>
#include <QMovie>

#define LOG_TAG "WaitingResDialog"
#include "logger.h"

WaitingResDialog::WaitingResDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::WaitingResDialog)
{
    ui->setupUi(this);

    this->setAttribute(Qt::WA_TranslucentBackground, true);
    setWindowFlags(Qt::FramelessWindowHint);
    ui->lableIcon->setAttribute(Qt::WA_TranslucentBackground, true);
    movie = new QMovie(":/imgs/juhua.gif", QByteArray(), this);
    ui->lableIcon->setMovie(movie);
}

WaitingResDialog::~WaitingResDialog()
{
    delete ui;
}

void WaitingResDialog::showEvent(QShowEvent *e)
{
    LOGT("show");
    movie->start();
    QApplication::postEvent(this, new QEvent(QEvent::UpdateRequest), Qt::LowEventPriority);
    QDialog::showEvent(e);
}

void WaitingResDialog::hideEvent(QHideEvent *e)
{
    LOGT("hide");
    movie->stop();
    QDialog::hideEvent(e);
}
