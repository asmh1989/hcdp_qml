#ifndef SINGLETONMANAGER_H
#define SINGLETONMANAGER_H

#include <QJsonObject>
#include <QObject>
#include <QSettings>
#include <QStringList>
#include <QThreadPool>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>

class SingletonManager : public QObject {
  Q_OBJECT
 public:
  static SingletonManager* instance();

  // 常量参数
  Q_PROPERTY(int constantValue READ constantValue CONSTANT)
  Q_PROPERTY(QList<QJsonObject> serialDataList READ serialDataList WRITE
                 setSerialDataList NOTIFY serialDataListChanged)
  Q_PROPERTY(QList<QJsonObject> saveSerialDataList READ saveSerialDataList WRITE
                 setSaveSerialDataList NOTIFY saveSerialDataListChanged)

  Q_PROPERTY(QString frameStart READ frameStart WRITE setFrameStart NOTIFY
                 frameStartChanged)
  Q_PROPERTY(
      QString frameEnd READ frameEnd WRITE setFrameEnd NOTIFY frameEndChanged)

  Q_PROPERTY(int encodeIndex READ encodeIndex WRITE setEncodeIndex NOTIFY
                 encodeIndexChanged)

  Q_PROPERTY(
      QString logPath READ getLogPath WRITE setLogPath NOTIFY logPathChanged)

  Q_PROPERTY(int crcType READ crcType WRITE setCrcType NOTIFY crcTypeChanged)

  Q_PROPERTY(int rxBytes READ rxBytes WRITE setRxBytes NOTIFY rxBytesChanged)
  Q_PROPERTY(
      int rxFrames READ rxFrames WRITE setRxFrames NOTIFY rxFramesChanged)
  Q_PROPERTY(int rxError READ rxError WRITE setRxError NOTIFY rxErrorChanged)

  Q_INVOKABLE QString getLogPath();
  Q_INVOKABLE void setLogPath(const QString& path);

  // 接口函数
  Q_INVOKABLE void showGlobalToast(QString msg);

  Q_INVOKABLE QStringList getSerialPortList();

  Q_INVOKABLE QString openSerialPort(int port, int rate);
  Q_INVOKABLE void closeSerialPort();
  Q_INVOKABLE void clearCache() {
    m_serialDataList.clear();
    emit serialDataListChanged();
  }
  Q_INVOKABLE void clearLog() { emit serialData(""); }

  Q_INVOKABLE void addDemo();
  Q_INVOKABLE void setStopBits(int b);
  Q_INVOKABLE void setParity(int b);
  Q_INVOKABLE void setAutoSaveLog(bool b) { m_autoSaveLog = b; }

  Q_INVOKABLE QString selectFile(const QUrl& url);

  Q_INVOKABLE QString getScaleCache();
  Q_INVOKABLE void setScaleCache(const QString& value);

  Q_INVOKABLE QString sendData(QString addr, QString code, QString data,
                               bool circle = false);

  int constantValue() const;

  QList<QJsonObject> serialDataList() const;
  void setSerialDataList(const QList<QJsonObject>& dataList);

  QList<QJsonObject> saveSerialDataList() const;
  void setSaveSerialDataList(const QList<QJsonObject>& dataList);

  QString frameStart() { return m_frameStart; }
  void setFrameStart(const QString& s) { m_frameStart = s; }
  QString frameEnd() { return m_frameEnd; }
  void setFrameEnd(const QString& s) { m_frameEnd = s; }
  int encodeIndex() { return m_encodeIndex; }
  void setEncodeIndex(int s) { m_encodeIndex = s; }

  int crcType() { return m_crcType; }
  void setCrcType(int t) { m_crcType = t; }

  int rxBytes() { return m_rxBytes; }
  void setRxBytes(int t) { m_rxBytes = t; }

  int rxFrames() { return m_rxFrames; }
  void setRxFrames(int t) { m_rxFrames = t; }

  int rxError() { return m_rxError; }
  void setRxError(int t) { m_rxError = t; }

  void refreshEmit(QString log) {
    emit serialDataListChanged();
    emit rxFramesChanged();
    emit rxErrorChanged();
    emit rxBytesChanged();
    emit serialData(log);
  }

 public slots:
  void receive();

 signals:
  // 信号用于触发回调
  void callbackSignal(const QString& message);
  void showToast(const QString& msg);
  void serialData(const QString& msg);
  void serialDataListChanged();
  void saveSerialDataListChanged();
  void frameStartChanged();
  void frameEndChanged();
  void encodeIndexChanged();
  void crcTypeChanged();
  void rxBytesChanged();
  void rxFramesChanged();
  void rxErrorChanged();
  void logPathChanged();

 private:
  explicit SingletonManager();
  ~SingletonManager();
  QByteArray decodeData(const QByteArray& d);
  void testParse(const QByteArray& d, int encode);
  void init();
  static SingletonManager* m_instance;
  int m_constantValue = 42;
  QSerialPort serial;  // 定义全局串口对象
  QByteArray buffer;
  QList<QSerialPortInfo> serialPortList;
  QThreadPool customThreadPool;

  QList<QJsonObject> m_serialDataList;
  QList<QJsonObject> m_saveSerialDataList;
  QString m_frameStart;
  QString m_frameEnd;
  int m_encodeIndex;
  int m_rxBytes;
  int m_rxFrames;
  int m_rxError;
  int m_crcType;
  QSerialPort::StopBits m_stopBits;
  QSerialPort::Parity m_Parity;
  QString m_logPath;
  bool m_autoSaveLog;
};

#endif  // SINGLETONMANAGER_H
