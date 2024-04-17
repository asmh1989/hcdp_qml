// SingletonManager.cpp
#include "singletonmanager.h"

#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>

#include "model.h"
#include "qaesencryption.h"
#include "utils.h"

SingletonManager *SingletonManager::m_instance = nullptr;

SingletonManager::SingletonManager()
{
  customThreadPool.setMaxThreadCount(2); // 设置最大线程数

  // 连接readyRead()信号，当串口有可用数据时触发
  QObject::connect(&serial, &QSerialPort::readyRead, this,
                   &SingletonManager::receive);

  init();
}

SingletonManager::~SingletonManager() {}

SerialData parseCrc(const QByteArray &inputByteArray)
{
  SerialData parsedData;

  auto size = inputByteArray.size();
  // 解析Address（前两个字节）
  parsedData.addr =
      QString("%1")
          .arg(static_cast<quint8>(inputByteArray[0]), 2, 16, QLatin1Char('0'))
          .toUpper();

  // 解析Code（第三个字节）
  parsedData.code =
      QString("%1")
          .arg(static_cast<quint8>(inputByteArray[1]), 2, 16, QLatin1Char('0'))
          .toUpper();

  qint16 status = (static_cast<quint8>(inputByteArray[2]) << 8) +
                  static_cast<quint8>(inputByteArray[3]);
  quint16 data_len = status & 0x0FFF;

  // 解析Quantity（第四和第五个字节）
  parsedData.quantity =
      QString("%1")
          .arg(static_cast<quint16>(status), 4, 16, QLatin1Char('0'))
          .toUpper();

  // 解析TimeStamp（接下来的四个字节）
  QByteArray timeStampArray = inputByteArray.mid(4, 4);
  parsedData.time = QString(timeStampArray.toHex()).toUpper();

  // 解析Data（接下来的八个字节）
  QByteArray dataArray = inputByteArray.mid(8, data_len - 4);
  parsedData.data = QString(dataArray.toHex()).toUpper();

  auto crc_c = inputByteArray.mid(0, size - 2);
  auto crc_cc = utils::calculate_modbus_crc(crc_c);
  parsedData.circle = crc_cc == inputByteArray;

  return parsedData;
}

void SingletonManager::receive()
{
  QByteArray receivedData = serial.readAll();
  buffer.append(receivedData);

  // 寻找帧头'$'
  int startIndex = buffer.indexOf('$');
  while (startIndex != -1)
  {
    // 寻找帧尾'\r'
    int endIndex = buffer.indexOf('\r', startIndex);
    if (endIndex != -1)
    {
      // 提取一帧内容
      QByteArray frameData =
          buffer.mid(startIndex + 1, endIndex - startIndex - 1);

      // 使用Lambda函数在线程池中处理数据
      auto processor = [frameData, this]()
      {
        // 在这里进行数据处理逻辑
        qDebug() << "Processing data: " << frameData;
        QDateTime currentDateTime = QDateTime::currentDateTime();
        QString formattedTime = currentDateTime.toString("hh:mm:ss.zzz");
        QString log;

        log.append("ReceTime: " + formattedTime + "\n");
        // log.append("Receive: Base64:    " + frameData + "\n");
        QByteArray encode = QByteArray::fromBase64(frameData);
        // log.append("Receive: Hex:       " + utils::formatQByte(encode) +
        //            " 解密前\n");
        QAESEncryption decryption(QAESEncryption::AES_128, QAESEncryption::ECB,
                                  QAESEncryption::PKCS7);
        QByteArray crcData2 =
            decryption.decode(encode, globalReadOnlyKey->toUtf8());
        QByteArray crcData =
            QAESEncryption::RemovePadding(crcData2, QAESEncryption::PKCS7);
        // log.append("Receive: Hex:       " + utils::formatQByte(crcData) + "\n");
        //                qDebug()<<log.toUtf8().constData();

        auto s = parseCrc(crcData);
        if (s.circle)
        {
          // log.append(QString("Receive: Data:      Address:%1   Code:%2   "
          //                    "Quantity:%3   TimeStamp:%4   Data:%5\n")
          //                .arg(s.addr, s.code, s.quantity, s.time, s.data));
        }
        else
        {
          log.append("Receive: Data:      ERROR!!\n");
        }

        emit serialData(log);
      };

      QThreadPool::globalInstance()->start(std::bind(processor));

      // 从缓存中移除已处理的数据
      buffer.remove(0, endIndex + 1);
    }
    else
    {
      // 如果没有找到帧尾，保留剩余数据到缓存中
      buffer = buffer.mid(startIndex);
      break;
    }

    // 寻找下一个帧头
    startIndex = buffer.indexOf('$');
  }
}

QStringList SingletonManager::getSerialPortList()
{
  QStringList availablePorts;
  serialPortList = QSerialPortInfo::availablePorts();
  // 将串口信息添加到字符串列表
  foreach (const QSerialPortInfo &serialPortInfo, serialPortList)
  {
    availablePorts.append(serialPortInfo.description() + " (" +
                          serialPortInfo.portName() + ")");
  }

  qDebug() << "Available Serial Ports:" << availablePorts;

  return availablePorts;
}

QString SingletonManager::openSerialPort(int port, int rate)
{
  auto p = serialPortList.at(port);
  qDebug() << "openSerialPort port = " << p.portName() << " rate = " << rate;
  serial.setPortName(p.portName());
  serial.setBaudRate(QSerialPort::Baud115200);
  serial.setDataBits(QSerialPort::Data8);
  serial.setFlowControl(QSerialPort::NoFlowControl);
  serial.setParity(QSerialPort::NoParity);
  serial.setStopBits(QSerialPort::OneStop);
  if (serial.isOpen())
  {
    return tr("Can't open %1").arg(p.portName());
  }
  if (!serial.open(QIODevice::ReadWrite))
  {
    return tr("Can't open %1, error code %2")
        .arg(p.portName())
        .arg(serial.error());
  }
  else
  {
    qDebug() << "openSerial success!";
  }

  return "";
}

void SingletonManager::closeSerialPort() { serial.close(); }

SingletonManager *SingletonManager::instance()
{
  if (!m_instance)
  {
    m_instance = new SingletonManager();
  }
  return m_instance;
}

int SingletonManager::constantValue() const { return m_constantValue; }

void SingletonManager::showGlobalToast(QString msg) { emit showToast(msg); }

QString SingletonManager::sendData(QString addr, QString code, QString data2,
                                   bool circle)
{
  addr.replace(" ", "");
  code.replace(" ", "");
  data2.replace(" ", "");
  QString data = data2;
  if (data2.contains('"'))
  {
    data = data2.toUtf8().toHex();
  }

  //    qDebug()<<"sendData: data = "<< data <<" circle = " <<circle;
  QString log;

  QDateTime currentDateTime = QDateTime::currentDateTime();
  QString formattedTime = currentDateTime.toString("hh:mm:ss.zzz");

  log.append("SendTime: " + formattedTime + " ====================== \n");

  uint32_t timeS =
      static_cast<uint32_t>(currentDateTime.toMSecsSinceEpoch() / 1000);
  auto time = QString("%1").arg(timeS, 4, 16, QLatin1Char('0')).toUpper();
  uint32_t len = (data.length() + time.length()) / 2;

  QString s_data;

  // 设备地址
  s_data.append(addr);
  // 功能码
  s_data.append(code);
  // 状态位和数据长度
  s_data.append(
      QString("%1").arg(len & 0x0FFF, 4, 16, QLatin1Char('0')).toUpper());
  // 时间戳
  s_data.append(time);
  // 数据
  s_data.append(data);

  auto s_byte = utils::convertQStringToByteArray(s_data);
  // log.append("Send: Hex:          " + utils::formatQByte(s_byte) + "\n");

  QByteArray crcData = utils::calculate_modbus_crc(s_byte);

  // Encrypt data using AES in ECB mode
  QAESEncryption encryption(QAESEncryption::AES_128, QAESEncryption::ECB,
                            QAESEncryption::PKCS7);

  QByteArray encryptedData =
      encryption.encode(crcData, globalReadOnlyKey->toUtf8());
  //    qDebug()<<"aes: " << utils::formatQByte(encryptedData);
  // log.append("Send: AllHex:       " + utils::formatQByte(encryptedData) + "\n");

  // Encode the encrypted data using base64 encoding
  QByteArray base64Data = encryptedData.toBase64();

  // Prepare final data packet
  QByteArray finalData = "$" + base64Data + "\r";
  //    qDebug() << "Final Data:" << finalData;

  // log.append("Send: Base64:       " + finalData + "\n");

  //    qDebug()<<log.toUtf8().constData();

  emit serialData(log);

  if (serial.isOpen())
  {
    serial.write(finalData);
    return "";
  }
  else
  {
    return "please open serial FIRST!!";
  }
}

void SingletonManager::clearCache() { emit serialData(""); }

QString loadJsonFile(QList<QJsonObject> &list, const QString &path)
{
  QFile file(path);
  if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
  {
    return QString("%1 cannot open").arg(path);
  }

  QByteArray jsonData = file.readAll();
  file.close();

  QJsonParseError parseError;
  QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonData, &parseError);
  if (jsonDoc.isNull())
  {
    qDebug() << "Failed to parse JSON: " << parseError.errorString()
             << " path = " << path;
    return QString("Failed to parse JSON: %1").arg(parseError.errorString());
  }

  if (!jsonDoc.isArray())
  {
    qDebug() << "Invalid JSON format: not an array";
    return "Invalid JSON format: not an array";
  }

  QJsonArray jsonArray = jsonDoc.array();
  for (const auto &jsonValue : jsonArray)
  {
    if (!jsonValue.isObject())
    {
      qDebug() << "Invalid JSON format: array contains non-object elements";
      continue;
    }

    QJsonObject jsonObj = jsonValue.toObject();
    SerialData data = SerialData::fromJson(jsonObj);

    list.append(data.toJson());
  }
  return "";
}

void SingletonManager::init()
{
  qDebug() << "SingletonManager::init ... ";

  loadJsonFile(m_serialDataList, "data/cache.json");

  if (m_serialDataList.isEmpty())
  {
    loadJsonFile(m_serialDataList, "data/data.json");
  }

  if (m_serialDataList.isEmpty())
  {
    QJsonObject jsonObj;
    m_serialDataList.append(SerialData::fromJson(jsonObj).toJson());
    m_serialDataList.append(SerialData::fromJson(jsonObj).toJson());
    m_serialDataList.append(SerialData::fromJson(jsonObj).toJson());
  }

  loadJsonFile(m_saveSerialDataList, "data/save.json");

  if (m_saveSerialDataList.isEmpty())
  {
    QJsonObject jsonObj;
    m_saveSerialDataList.append(SerialData::fromJson(jsonObj).toJson());
    m_saveSerialDataList.append(SerialData::fromJson(jsonObj).toJson());
    m_saveSerialDataList.append(SerialData::fromJson(jsonObj).toJson());
  }
}

void saveJsonFile(const QList<QJsonObject> &list, const QString &path)
{
  // 获取文件目录
  QDir dir(QFileInfo(path).path());

  // 如果目录不存在，创建目录
  if (!dir.exists())
  {
    dir.mkpath(".");
  }

  QFile file(path);
  if (file.open(QIODevice::WriteOnly))
  {
    QJsonArray jsonArray;

    // 将QList<QJsonObject>转换为QJsonArray
    for (const auto &jsonObj : list)
    {
      jsonArray.append(jsonObj);
    }

    QJsonDocument jsonDoc(jsonArray);
    file.write(jsonDoc.toJson());
    file.close();
    qDebug() << "JSON data saved to: " << path;
  }
  else
  {
    qDebug() << "Failed to save JSON data to: " << path << file.errorString();
  }
}

QList<QJsonObject> SingletonManager::serialDataList() const
{
  return m_serialDataList;
}

void SingletonManager::setSerialDataList(const QList<QJsonObject> &dataList)
{
  if (m_serialDataList != dataList)
  {
    m_serialDataList = dataList;
    emit serialDataListChanged();
    saveJsonFile(dataList, "data/cache.json");
  }
}

QList<QJsonObject> SingletonManager::saveSerialDataList() const
{
  return m_saveSerialDataList;
}

void SingletonManager::setSaveSerialDataList(
    const QList<QJsonObject> &dataList)
{
  if (m_saveSerialDataList != dataList)
  {
    m_saveSerialDataList = dataList;
    emit saveSerialDataListChanged();
    saveJsonFile(dataList, "data/save.json");
  }
}

QString SingletonManager::selectFile(const QUrl &url)
{
  QList<QJsonObject> list;
  QString res = loadJsonFile(list, url.toLocalFile());
  if (res.isEmpty())
  {
    setSerialDataList(list);
  }
  return res;
}

QString SingletonManager::getScaleCache()
{
  QSettings settings("MyCompany", "MyApp");
  QString scale = settings.value("QT_SCALE_FACTOR", "1.25").toString();
  if (scale == "1.2")
  {
    scale = "1.25";
  }
  return scale;
}

void SingletonManager::setScaleCache(const QString &value)
{
  QSettings settings("MyCompany", "MyApp");
  settings.setValue("QT_SCALE_FACTOR", value);
}
