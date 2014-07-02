#ifndef WAITINGRESDIALOG_H
#define WAITINGRESDIALOG_H

#include <QDialog>

namespace Ui {
class WaitingResDialog;
}

class WaitingResDialog : public QDialog
{
    Q_OBJECT
    
public:
    explicit WaitingResDialog(QWidget *parent = 0);
    ~WaitingResDialog();

protected:
    void showEvent(QShowEvent *);
    void hideEvent(QHideEvent *);
private:
    Ui::WaitingResDialog *ui;
    QMovie* movie;
};

#endif // WAITINGRESDIALOG_H
