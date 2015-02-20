#ifndef COCOSWIDGET_H
#define COCOSWIDGET_H

#include <QWidget>

namespace Ui {
class CocosWidget;
}

class CocosWidget : public QWidget
{
    Q_OBJECT

public:
    explicit CocosWidget(QWidget *parent = 0);
    ~CocosWidget();

private:
    Ui::CocosWidget *ui;
};

#endif // COCOSWIDGET_H
