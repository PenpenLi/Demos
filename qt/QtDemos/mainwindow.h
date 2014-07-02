#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

class TestDialog;
class CustomDialog;
class WaitingResDialog;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

protected:
    bool event(QEvent *event);
    void moveEvent(QMoveEvent*);
    void resizeEvent(QResizeEvent*);

private:
    Ui::MainWindow *ui;
    TestDialog *testDlg;
    WaitingResDialog *waitDlg;

    void updateUI(QPoint pt, QSize size);

private slots:
    void onTest();
};

#endif // MAINWINDOW_H
