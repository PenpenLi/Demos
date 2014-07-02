#ifndef TESTDIALOG_H
#define TESTDIALOG_H

#include "customdialog.h"

namespace Ui {
class TestDialog;
}

class TestDialog : public CustomDialog
{
    Q_OBJECT

public:
    explicit TestDialog(QWidget *parent = 0);
    ~TestDialog();

private:
    Ui::TestDialog *ui;
};

#endif // TESTDIALOG_H
