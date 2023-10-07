#ifndef SINGLETONMANAGER_H
#define SINGLETONMANAGER_H

#include <QObject>
#include <functional>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QStringList>
#include <QThreadPool>


class SingletonManager : public QObject
{
    Q_OBJECT
public:
    static SingletonManager* instance();

    // 常量参数
    Q_PROPERTY(int constantValue READ constantValue CONSTANT)

    // 接口函数
    Q_INVOKABLE void doSomething();
    Q_INVOKABLE void showGlobalToast(QString msg);

    Q_INVOKABLE QStringList  getSerialPortList();

    Q_INVOKABLE QString  openSerialPort(int port, int rate);
    Q_INVOKABLE void  closeSerialPort();
    Q_INVOKABLE void  clearCache();

    Q_INVOKABLE QString  sendData(QString addr, QString code, QString data, bool circle = false);


    int constantValue() const;

    // 回调函数类型
    using CallbackFunction = std::function<void(const QString& message)>;

    // 设置回调函数
    void setCallback(const CallbackFunction& callback);
public slots:
    void receive();

signals:
    // 信号用于触发回调
    void callbackSignal(const QString& message);
    void showToast(const QString& msg);
    void serialData(const QString& msg);

private:
    explicit SingletonManager();
    ~SingletonManager();
    static SingletonManager* m_instance;
    int m_constantValue = 42;
    QSerialPort serial;                            // 定义全局串口对象
    CallbackFunction m_callback;
    QByteArray buffer;
    QList<QSerialPortInfo> serialPortList;
    QThreadPool customThreadPool;

};


#endif // SINGLETONMANAGER_H
