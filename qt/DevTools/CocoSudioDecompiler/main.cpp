#include "mainwindow.h"
#include <QApplication>

#define LOG_TAG "main"
#include "logger.h"

int main(int argc, char *argv[])
{
    LOGGER->initLogSystem(argc, argv);

    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();
}
