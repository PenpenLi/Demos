#-------------------------------------------------
#
# Project created by QtCreator 2014-07-02T00:30:35
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = QtDemos
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    customdialog.cpp \
    testdialog.cpp \
    customwidget.cpp \
    waitingresdialog.cpp \
    testform.cpp

HEADERS  += mainwindow.h \
    customdialog.h \
    testdialog.h \
    customwidget.h \
    waitingresdialog.h \
    testform.h

FORMS    += mainwindow.ui \
    testdialog.ui \
    waitingresdialog.ui \
    testform.ui

RESOURCES += \
    res.qrc
