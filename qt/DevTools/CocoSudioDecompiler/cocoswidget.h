#ifndef COCOSWIDGET_H
#define COCOSWIDGET_H

#include <QWidget>
#include <QTimer>

class CocosWidget : public QWidget
{
    Q_OBJECT

public:
    explicit CocosWidget(QWidget *parent = 0);
    ~CocosWidget();

private:
//    QTimer _cocosTimer;
    QThread _cocosThread;

private slots:
    void cocosLoop();
};

#endif // COCOSWIDGET_H
