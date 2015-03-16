#ifndef COCOSRUNNER_H
#define COCOSRUNNER_H

#include <QObject>
#include <QThread>

class CocosRunner : public QObject
{
    Q_OBJECT
public:
    explicit CocosRunner(QObject *parent = 0);
    ~CocosRunner();

    void Run();
    void Stop();

private slots:
    void Started();
    void Stopped();

signals:
    void cocosReady();

private:
    QThread _cocosThread;
};

#endif // COCOSRUNNER_H
