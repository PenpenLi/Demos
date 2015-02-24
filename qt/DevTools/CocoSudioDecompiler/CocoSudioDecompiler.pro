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

INCLUDEPATH +=  \
    $$PWD/../DevBase

LIBS +=             \
    -L$$PWD/../@lib \
    -lDevBase

SOURCES += main.cpp\
        mainwindow.cpp \
    cocoswidget.cpp

HEADERS  += mainwindow.h \
    cocoswidget.h

FORMS    += mainwindow.ui
