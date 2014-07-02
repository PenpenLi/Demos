#include "testdialog.h"
#include "ui_testdialog.h"

TestDialog::TestDialog(QWidget *parent) :
    CustomDialog(parent),
    ui(new Ui::TestDialog)
{
    ui->setupUi(this);
//    hide();
}

TestDialog::~TestDialog()
{
    delete ui;
}
