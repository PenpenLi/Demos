#ifndef CUSTOMDIALOG_H
#define CUSTOMDIALOG_H

#include <QDialog>

class CustomDialog : public QDialog
{
    Q_OBJECT
public:
    explicit CustomDialog(QWidget *parent = 0);

protected:
    void paintEvent(QPaintEvent *);
    void showEvent(QShowEvent *);
    void hideEvent(QHideEvent *);
    bool eventFilter(QObject *, QEvent *);
    bool event(QEvent *);

signals:

public slots:

private:

};

#endif // CUSTOMDIALOG_H
