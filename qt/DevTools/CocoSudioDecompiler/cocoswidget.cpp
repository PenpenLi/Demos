#include "cocoswidget.h"
#include "ui_cocoswidget.h"

CocosWidget::CocosWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::CocosWidget)
{
    ui->setupUi(this);
}

CocosWidget::~CocosWidget()
{
    delete ui;
}
