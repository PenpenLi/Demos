#ifndef QGLVIEWIMPL_H
#define QGLVIEWIMPL_H
#include "platform/CCGLView.h"
//#include "platform/CCGL.h"
#include "cocos2d.h"
//#include <QtOpenGL/QtOpenGL>
#include <QtGui/QOpenGLContext>
#include <QtGui/QSurface>
//#include <QtGui/qopengl.h>

#include <QWidget>
#include <QOpenGLWidget>
#include <QOpenGLFunctions>

using cocos2d::Rect;

class QGLViewImpl : public QOpenGLWidget, public cocos2d::GLView, protected QOpenGLFunctions
{
    Q_OBJECT
public:
    explicit QGLViewImpl(QWidget *parent = 0);
    ~QGLViewImpl();

    static QGLViewImpl* create(const std::string& viewName);

    virtual void end() override;
    virtual bool isOpenGLReady() override { return _isInited; }
    virtual void swapBuffers() override;
    virtual void setIMEKeyboardState(bool bOpen) override;
    virtual void setFrameSize(float width, float height) override;

    virtual id getCocoaWindow() override { return nullptr; }

protected:
    bool initWithRect(const std::string& viewName, Rect rect, float frameZoomFactor);
    bool initGlew();


    virtual void initializeGL() override;

signals:

public slots:

private:
    bool _isInited;
};

#endif // QGLVIEWIMPL_H
