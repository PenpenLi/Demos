#include "mainwindow.h"
#include <QApplication>

//// cocos test
//#include "AppDelegate.h"
//USING_NS_CC;

#define LOG_TAG "main"
#include "logger.h"

int main(int argc, char *argv[])
{
    LOGGER->initLogSystem(argc, argv);

    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();

//    // cocos test
//    AppDelegate app;
//    Application::getInstance()->run();
}
