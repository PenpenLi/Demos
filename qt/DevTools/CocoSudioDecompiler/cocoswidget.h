#ifndef COCOSWIDGET_H
#define COCOSWIDGET_H

#include <QWidget>
#include <QThread>

class CocosRunner;

class CocosWidget : public QWidget
{
    Q_OBJECT

public:
    explicit CocosWidget(QWidget *parent = 0);
    ~CocosWidget();

protected:
    virtual void moveEvent(QMoveEvent *) override;
    virtual void resizeEvent(QResizeEvent *) override;
    virtual void closeEvent(QCloseEvent *) override;

private:
    CocosRunner *_runner;

private slots:
    void onCocosReady();
};

#endif // COCOSWIDGET_H
