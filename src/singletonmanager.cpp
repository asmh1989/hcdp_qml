// SingletonManager.cpp
#include "singletonmanager.h"
#include <QDebug>


SingletonManager* SingletonManager::m_instance = nullptr;

SingletonManager::SingletonManager() {
}

SingletonManager::~SingletonManager(){
}

void SingletonManager::receive()
{
    QByteArray data = serial.readAll();
    qDebug() << "Received data: " << data;
}

QStringList  SingletonManager::getSerialPortList() {
    QStringList availablePorts;
    serialPortList = QSerialPortInfo::availablePorts();
    // 将串口信息添加到字符串列表
    foreach (const QSerialPortInfo &serialPortInfo, serialPortList) {
        availablePorts.append(serialPortInfo.description() +" ("+serialPortInfo.portName()+")");
    }

    qDebug() << "Available Serial Ports:" << availablePorts;

    return availablePorts;
}

QString SingletonManager::openSerialPort(int port, int rate){
    auto p = serialPortList.at(port);
    qDebug()<< "openSerialPort port = " << p.portName() << " rate = " << rate;
    serial.setPortName(p.portName());
    serial.setBaudRate(QSerialPort::Baud115200);
    serial.setDataBits(QSerialPort::Data8);
    serial.setFlowControl(QSerialPort::NoFlowControl);
    serial.setParity(QSerialPort::NoParity);
    serial.setStopBits(QSerialPort::OneStop);
    if(serial.isOpen()){
        return tr("Can't open %1").arg(p.portName());
    }
    if (!serial.open(QIODevice::ReadWrite)) {
        return tr("Can't open %1, error code %2")
            .arg(p.portName()).arg(serial.error());
    } else {
        qDebug()<< "openSerial success!";
    }


    return "";
}

void SingletonManager::closeSerialPort(){
    serial.close();
}

SingletonManager* SingletonManager::instance()
{
    if (!m_instance) {
        m_instance = new SingletonManager();
    }
    return m_instance;
}

int SingletonManager::constantValue() const
{
    return m_constantValue;
}

void SingletonManager::showToast(QString msg) {
    emit onShowToast(msg);
}

void SingletonManager::doSomething()
{
    // 执行一些操作
    if (m_callback) {
        m_callback("Operation completed.");
    }
}

void SingletonManager::setCallback(const CallbackFunction& callback)
{
    m_callback = callback;
}
