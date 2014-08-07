#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QToolButton>
#include <QDebug>
#include <QMoveEvent>
#include <QResizeEvent>

#include "testdialog.h"
#include "waitingresdialog.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow),
    testDlg(new TestDialog(this)),
    waitDlg(new WaitingResDialog(this))
{
    ui->setupUi(this);
    QToolButton *btnTest = new QToolButton;
    btnTest->setStyleSheet("background-color: red");
    btnTest->setText(tr("test"));
    connect(btnTest, SIGNAL(clicked()), this, SLOT(onTest()));
    ui->mainToolBar->addWidget(btnTest);
    waitDlg->show();
}

MainWindow::~MainWindow()
{
    delete ui;
}

bool MainWindow::event(QEvent *event)
{
    switch (event->type()) {
    case QEvent::Move:
        qDebug() << "Move";
        qDebug() << "before: " << this->pos();
        qDebug() << "event: " << ((QMoveEvent *)event)->pos();
        break;
    case QEvent::Resize:
        qDebug() << "Resize";
        break;
    default:
        break;
    }
    return QMainWindow::event(event);
}

void MainWindow::moveEvent(QMoveEvent *e)
{
    QPoint pt((this->width()-waitDlg->width())/2.0, (this->height()-waitDlg->height())/2.0);
    waitDlg->move(this->mapToGlobal(pt));
    if (testDlg->isVisible())
    {
        pt = ui->screen->pos();
        testDlg->move(ui->screen->mapToGlobal(QPoint(0, 0)));
    }

}

void MainWindow::resizeEvent(QResizeEvent *e)
{
    qDebug() << "resizeEvent";
    QPoint pt((e->size().width()-waitDlg->width())/2.0, (e->size().height()-waitDlg->height())/2.0);
    waitDlg->move(this->mapToGlobal(pt));
    if (testDlg->isVisible())
    {
        testDlg->resize(ui->screen->size());
        pt = ui->screen->pos();
        testDlg->move(ui->screen->mapToGlobal(QPoint(0, 0)));
    }
}

void MainWindow::updateUI(QPoint pt, QSize size)
{

}

void MainWindow::onTest()
{
    QPoint globalPoint(ui->screen->mapToGlobal(QPoint(0, 0)));
    testDlg->resize(ui->screen->size());
    testDlg->move(globalPoint);
    testDlg->show();
}
