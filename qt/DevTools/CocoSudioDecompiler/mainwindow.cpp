#include "mainwindow.h"
#include "ui_mainwindow.h"

#define LOG_TAG "MainWindow"
#include "logger.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    LOGT("MainWindow: parent=" << parent);
}

MainWindow::~MainWindow()
{
    delete ui;
}
