#include "WaitingResDialog.h"
#include "ui_WaitingResDialog.h"
#include <QPainter>
#include <QMovie>

WaitingResDialog::WaitingResDialog(QWidget *parent) :
    QDialog(parent, Qt::Sheet | Qt::FramelessWindowHint | Qt::CustomizeWindowHint),
    ui(new Ui::WaitingResDialog)
{
    ui->setupUi(this);

//    setWindowModality(Qt::ApplicationModal);
//    setModal(true);

    this->setAttribute(Qt::WA_TranslucentBackground, true);
//    setWindowFlags(Qt::FramelessWindowHint);
    ui->lableIcon->setAttribute(Qt::WA_TranslucentBackground, true);
    movie = new QMovie("://juhua.gif", QByteArray(), this);
    ui->lableIcon->setMovie(movie);
    hide();
}

WaitingResDialog::~WaitingResDialog()
{
    delete ui;
}

void WaitingResDialog::showEvent(QShowEvent *e)
{
    movie->start();
    QApplication::postEvent(this, new QEvent(QEvent::UpdateRequest), Qt::LowEventPriority);
    QDialog::showEvent(e);
}

void WaitingResDialog::hideEvent(QHideEvent *e)
{
    movie->stop();
    QDialog::hideEvent(e);
}
