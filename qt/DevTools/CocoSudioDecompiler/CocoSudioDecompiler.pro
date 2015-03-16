#-------------------------------------------------
#
# Project created by QtCreator 2015-01-25T10:01:05
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = CocoSudioDecompiler
TEMPLATE = app

DESTDIR = $$PWD/../@bin

macx {
    INCLUDEPATH += \
        /Users/xiaobin/Documents/codes/cocos2d-x-3.4/cocos \
        /Users/xiaobin/Documents/codes/cocos2d-x-3.4/external/glfw3/include/mac \
        /System/Library/Frameworks

    LIBS += \
        -framework Cocoa \
        -framework OpenGL \
        -framework AudioToolbox \
        -framework OpenAL \
        -framework QuartzCore \
        -framework ApplicationServices \
        -framework IOKit \
        -framework Foundation

    OBJECTIVE_SOURCES += \
        cocoswidget.mm
}

INCLUDEPATH +=  \
    $$PWD/../DevBase \
    $$PWD/../3rd/include

LIBS +=             \
    -L$$PWD/../@lib \
    -lDevBase   \
    -lcocos2d   \
    -lpng   \
    -lz

SOURCES += main.cpp \
    mainwindow.cpp  \
    AppDelegate.cpp \
    cocosrunner.cpp

HEADERS  += mainwindow.h \
    cocoswidget.h \
    AppDelegate.h \
    cocosrunner.h

FORMS += mainwindow.ui

CONFIG += c++11
