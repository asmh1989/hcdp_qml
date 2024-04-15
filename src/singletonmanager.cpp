// SingletonManager.cpp
#include "singletonmanager.h"

#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QTextCodec>

#include "model.h"
#include "qaesencryption.h"
#include "utils.h"

SingletonManager *SingletonManager::m_instance = nullptr;
QSettings settings("MyCompany", "MyApp");
const QString LOG_KEY = "__log_path_";

QJsonObject newJson() {
  QString jsonString =
      "{\"Data\":\"09\",\"dgLen\":\"0001\",\"dgTag\":\"0505\",\"dstAddr\":"
      "\"02\",\"dstPt\":\"06\",\"error\":\"\",\"fmCls\":\"01\",\"fmLen\":"
      "\"0007\",\"srcAddr\":\"03\",\"srcPt\":\"07\",\"time\":\"16:34:20.169\","
      "\"crc\":\"273E\"}";
  QJsonObject jsonObject;
  QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonString.toUtf8());
  if (!jsonDocument.isNull() && jsonDocument.isObject()) {
    jsonObject = jsonDocument.object();
  }
  return jsonObject;
}

SerialData parseCrc(const QByteArray &inputByteArray) {
  SerialData parsedData;

  auto size = inputByteArray.size();
  if (size < 13) {
    parsedData.error = "帧长度不到13";
    return parsedData;
  }

  auto crc_c = inputByteArray.mid(0, size - 2);
  if (inputByteArray != utils::calculate_modbus_crc(crc_c)) {
    parsedData.error = "crc error";
    return parsedData;
  }

  parsedData.fmCls =
      QString("%1")
          .arg(static_cast<quint8>(inputByteArray[0]), 2, 16, QLatin1Char('0'))
          .toUpper();

  parsedData.dstAddr =
      QString("%1")
          .arg(static_cast<quint8>(inputByteArray[1]), 2, 16, QLatin1Char('0'))
          .toUpper();

  parsedData.srcAddr =
      QString("%1")
          .arg(static_cast<quint8>(inputByteArray[2]), 2, 16, QLatin1Char('0'))
          .toUpper();

  qint16 status = (static_cast<quint8>(inputByteArray[3]) << 8) +
                  static_cast<quint8>(inputByteArray[4]);

  parsedData.fmLen =
      QString("%1")
          .arg(static_cast<quint16>(status), 4, 16, QLatin1Char('0'))
          .toUpper();

  status = (static_cast<quint8>(inputByteArray[5]) << 8) +
           static_cast<quint8>(inputByteArray[6]);

  parsedData.dgTag =
      QString("%1")
          .arg(static_cast<quint16>(status), 4, 16, QLatin1Char('0'))
          .toUpper();

  parsedData.dstPt = QString("%1").arg(static_cast<quint8>(inputByteArray[7]),
                                       2, 16, QLatin1Char('0'));

  parsedData.srcPt = QString("%1").arg(static_cast<quint8>(inputByteArray[8]),
                                       2, 16, QLatin1Char('0'));

  status = (static_cast<quint8>(inputByteArray[9]) << 8) +
           static_cast<quint8>(inputByteArray[10]);

  parsedData.dgLen =
      QString("%1")
          .arg(static_cast<quint16>(status), 4, 16, QLatin1Char('0'))
          .toUpper();
  QByteArray dataArray = inputByteArray.mid(11, size - 11 - 2);

  parsedData.Data = QString(dataArray.toHex()).toUpper();

  status = (static_cast<quint8>(inputByteArray[size - 2]) << 8) +
           static_cast<quint8>(inputByteArray[size - 1]);

  parsedData.crc =
      QString("%1")
          .arg(static_cast<quint16>(status), 4, 16, QLatin1Char('0'))
          .toUpper();

  return parsedData;
}

void SingletonManager::testParse(const QByteArray &test1, int encode) {
  m_encodeIndex = encode;
  qDebug() << "ori hex = " << utils::formatQByte(test1);
  auto d = decodeData(test1);
  qDebug() << "decode hex = " << utils::formatQByte(test1);

  auto p = parseCrc(d);
  qDebug() << "010203000705050607000109273E : " << p.toJson();
}

SingletonManager::SingletonManager()
    : m_frameStart("24"),
      m_frameEnd("0d"),
      m_encodeIndex(0),
      m_rxBytes(0),
      m_rxFrames(0),
      m_rxError(0),
      m_logPath(""),
      m_autoSaveLog(true),
      m_stopBits(QSerialPort::OneStop),
      m_Parity(QSerialPort::NoParity),
      m_crcType(0) {
  customThreadPool.setMaxThreadCount(2);  // 设置最大线程数

  // 连接readyRead()信号，当串口有可用数据时触发
  QObject::connect(&serial, &QSerialPort::readyRead, this,
                   &SingletonManager::receive);

  // auto test1 = QByteArray::fromHex("010203000705050607000109273E");
  // testParse(test1, 1);

  // auto test2 = QString("AQIDAAcFBQYHAAEJJz4=").toUtf8();
  // testParse(test2, 0);
  init();
}

SingletonManager::~SingletonManager() {}

QByteArray toByteArray(const QString &searchString) {
  QString hexString = searchString.left(2);  // 获取QString的前两个字符
  if (hexString.length() == 1)
    hexString.prepend('0');  // 如果只有一个字符，添加一个0

  return QByteArray::fromHex(hexString.toUtf8());  // 将前两位字符转换成一个字节
}

QByteArray SingletonManager::decodeData(const QByteArray &d) {
  if (m_encodeIndex == 1) {
    // QTextCodec *codec = QTextCodec::codecForName("ASCII");
    // QString asciiString = codec->toUnicode(d);
    // return asciiString.toUtf8();
    return d;
  }
  return QByteArray::fromBase64(d);
}

QString jsonToStr(QJsonObject j) {
  QJsonDocument jsonDocument(j);
  return jsonDocument.toJson(QJsonDocument::Compact);
}

void SingletonManager::addDemo() {
  auto d = newJson();
  m_serialDataList.append(d);
  emit serialDataListChanged();
  emit serialData(jsonToStr(d));
  emit serialData(" <font color=\"green\">parse success</font>");
}

void SingletonManager::receive() {
  QByteArray receivedData = serial.readAll();
  m_rxBytes += receivedData.length();
  emit rxBytesChanged();
  buffer.append(receivedData);
  auto fs = toByteArray(m_frameStart);
  auto fe = toByteArray(m_frameEnd);

  // 寻找帧头'$'
  int startIndex = buffer.indexOf(fs);
  while (startIndex != -1) {
    // 寻找帧尾'\r'
    int endIndex = buffer.indexOf(fe, startIndex);
    if (endIndex != -1) {
      // 提取一帧内容
      QByteArray frameData =
          buffer.mid(startIndex + 1, endIndex - startIndex - 1);

      // 使用Lambda函数在线程池中处理数据
      auto processor = [frameData, this]() {
        // 在这里进行数据处理逻辑
        // qDebug() << "Processing data: " << frameData;
        QDateTime currentDateTime = QDateTime::currentDateTime();
        QString formattedTime = currentDateTime.toString("hh:mm:ss.zzz");
        QString log;

        log.append("Receive: Time: " + formattedTime + " ");
        log.append("encode: " + utils::formatQByte(frameData) + " ");

        QByteArray encode = decodeData(frameData);

        auto s = parseCrc(encode);
        m_rxFrames += 1;

        if (s.error.isEmpty()) {
          m_serialDataList.append(s.toJson());
          log.append(" <font color=\"green\">parse success</font>");
        } else {
          m_rxError += 1;
          log.append(" <font color=\"red\">parse Error:" + s.error + "</font>");
        }
        refreshEmit(log);
        if (m_autoSaveLog) {
          if (s.error.isEmpty()) {
            log.append(" JSON: ");
            log.append(
                QJsonDocument(s.toJson()).toJson(QJsonDocument::Compact));
          }
          utils::recordLog(log);
        }
      };

      QThreadPool::globalInstance()->start(std::bind(processor));

      // 从缓存中移除已处理的数据
      buffer.remove(0, endIndex + 1);
    } else {
      // 如果没有找到帧尾，保留剩余数据到缓存中
      buffer = buffer.mid(startIndex);
      break;
    }

    // 寻找下一个帧头
    startIndex = buffer.indexOf('$');
  }
}

QStringList SingletonManager::getSerialPortList() {
  QStringList availablePorts;
  serialPortList = QSerialPortInfo::availablePorts();
  // 将串口信息添加到字符串列表
  foreach (const QSerialPortInfo &serialPortInfo, serialPortList) {
    availablePorts.append(serialPortInfo.description() + " (" +
                          serialPortInfo.portName() + ")");
  }

  // qDebug() << "Available Serial Ports:" << availablePorts;

  return availablePorts;
}

QString SingletonManager::openSerialPort(int port, int rate) {
  auto p = serialPortList.at(port);
  // qDebug() << "openSerialPort port = " << p.portName() << " rate = " << rate;
  serial.setPortName(p.portName());
  serial.setBaudRate(QSerialPort::Baud115200);
  serial.setDataBits(QSerialPort::Data8);
  serial.setFlowControl(QSerialPort::NoFlowControl);
  serial.setParity(m_Parity);
  serial.setStopBits(m_stopBits);
  if (serial.isOpen()) {
    return tr("Can't open %1").arg(p.portName());
  }
  if (!serial.open(QIODevice::ReadWrite)) {
    return tr("Can't open %1, error code %2")
        .arg(p.portName())
        .arg(serial.error());
  } else {
    qDebug() << "openSerial success!";
  }

  m_rxBytes = 0;
  m_rxFrames = 0;
  m_rxError = 0;
  refreshEmit("serial open! " + p.portName());

  return "";
}

void SingletonManager::closeSerialPort() {
  refreshEmit("serial close!");
  serial.close();
}

SingletonManager *SingletonManager::instance() {
  if (!m_instance) {
    m_instance = new SingletonManager();
  }
  return m_instance;
}

int SingletonManager::constantValue() const { return m_constantValue; }

void SingletonManager::showGlobalToast(QString msg) { emit showToast(msg); }

QString SingletonManager::sendData(QString addr, QString code, QString data2,
                                   bool circle) {
  addr.replace(" ", "");
  code.replace(" ", "");
  data2.replace(" ", "");
  QString data = data2;
  if (data2.contains('"')) {
    data = data2.toUtf8().toHex();
  }

  //    qDebug()<<"sendData: data = "<< data <<" circle = " <<circle;
  QString log;

  QDateTime currentDateTime = QDateTime::currentDateTime();
  QString formattedTime = currentDateTime.toString("hh:mm:ss.zzz");

  log.append("Send: Time:         " + formattedTime + "\n");

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
  log.append("Send: Hex:          " + utils::formatQByte(s_byte) + "\n");

  QByteArray crcData = utils::calculate_modbus_crc(s_byte);

  // Encrypt data using AES in ECB mode
  QAESEncryption encryption(QAESEncryption::AES_128, QAESEncryption::ECB,
                            QAESEncryption::PKCS7);

  QByteArray encryptedData =
      encryption.encode(crcData, globalReadOnlyKey->toUtf8());
  //    qDebug()<<"aes: " << utils::formatQByte(encryptedData);
  log.append("Send: AllHex:       " + utils::formatQByte(encryptedData) + "\n");

  // Encode the encrypted data using base64 encoding
  QByteArray base64Data = encryptedData.toBase64();

  // Prepare final data packet
  QByteArray finalData = "$" + base64Data + "\r";
  //    qDebug() << "Final Data:" << finalData;

  log.append("Send: Base64:       " + finalData + "\n");

  //    qDebug()<<log.toUtf8().constData();

  emit serialData(log);

  if (serial.isOpen()) {
    serial.write(finalData);
    return "";
  } else {
    return "please open serial FIRST!!";
  }
}

QString loadJsonFile(QList<QJsonObject> &list, const QString &path) {
  QFile file(path);
  if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
    return QString("%1 cannot open").arg(path);
  }

  QByteArray jsonData = file.readAll();
  file.close();

  QJsonParseError parseError;
  QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonData, &parseError);
  if (jsonDoc.isNull()) {
    qDebug() << "Failed to parse JSON: " << parseError.errorString()
             << " path = " << path;
    return QString("Failed to parse JSON: %1").arg(parseError.errorString());
  }

  if (!jsonDoc.isArray()) {
    qDebug() << "Invalid JSON format: not an array";
    return "Invalid JSON format: not an array";
  }

  QJsonArray jsonArray = jsonDoc.array();
  for (const auto &jsonValue : jsonArray) {
    if (!jsonValue.isObject()) {
      qDebug() << "Invalid JSON format: array contains non-object elements";
      continue;
    }

    QJsonObject jsonObj = jsonValue.toObject();
    SerialData data = SerialData::fromJson(jsonObj);

    list.append(data.toJson());
  }
  return "";
}

void SingletonManager::init() {}

void saveJsonFile(const QList<QJsonObject> &list, const QString &path) {
  // 获取文件目录
  QDir dir(QFileInfo(path).path());

  // 如果目录不存在，创建目录
  if (!dir.exists()) {
    dir.mkpath(".");
  }

  QFile file(path);
  if (file.open(QIODevice::WriteOnly)) {
    QJsonArray jsonArray;

    // 将QList<QJsonObject>转换为QJsonArray
    for (const auto &jsonObj : list) {
      jsonArray.append(jsonObj);
    }

    QJsonDocument jsonDoc(jsonArray);
    file.write(jsonDoc.toJson());
    file.close();
    qDebug() << "JSON data saved to: " << path;
  } else {
    qDebug() << "Failed to save JSON data to: " << path << file.errorString();
  }
}

QList<QJsonObject> SingletonManager::serialDataList() const {
  return m_serialDataList;
}

void SingletonManager::setSerialDataList(const QList<QJsonObject> &dataList) {
  if (m_serialDataList != dataList) {
    m_serialDataList = dataList;
    emit serialDataListChanged();
    saveJsonFile(dataList, "data/cache.json");
  }
}

QList<QJsonObject> SingletonManager::saveSerialDataList() const {
  return m_saveSerialDataList;
}

void SingletonManager::setSaveSerialDataList(
    const QList<QJsonObject> &dataList) {
  if (m_saveSerialDataList != dataList) {
    m_saveSerialDataList = dataList;
    emit saveSerialDataListChanged();
    saveJsonFile(dataList, "data/save.json");
  }
}

QString SingletonManager::selectFile(const QUrl &url) {
  QList<QJsonObject> list;
  QString res = loadJsonFile(list, url.toLocalFile());
  if (res.isEmpty()) {
    setSerialDataList(list);
  }
  return res;
}

QString SingletonManager::getScaleCache() {
  QString scale = settings.value("QT_SCALE_FACTOR", "1.25").toString();
  if (scale == "1.2") {
    scale = "1.25";
  }
  return scale;
}

void SingletonManager::setScaleCache(const QString &value) {
  settings.setValue("QT_SCALE_FACTOR", value);
}

QString SingletonManager::getLogPath() {
  if (m_logPath.isEmpty()) {
    if (settings.contains(LOG_KEY)) {
      m_logPath = settings.value(LOG_KEY).toString();
    } else {
      m_logPath = QCoreApplication::applicationDirPath() + "/log";
      setLogPath(m_logPath);
    }
  }
  return m_logPath;
}

void SingletonManager::setLogPath(const QString &p) {
  m_logPath = p;
  settings.setValue(LOG_KEY, p);
  emit logPathChanged();
}

void SingletonManager::setStopBits(int b) {
  switch (b) {
    case 1:
      m_stopBits = QSerialPort::OneAndHalfStop;
      break;
    case 2:
      m_stopBits = QSerialPort::TwoStop;
      break;
    default:
      m_stopBits = QSerialPort::OneStop;
  }
}

void SingletonManager::setParity(int b) {
  switch (b) {
    case 2:
      m_Parity = QSerialPort::EvenParity;
      break;
    case 3:
      m_Parity = QSerialPort::OddParity;
      break;
    case 4:
      m_Parity = QSerialPort::SpaceParity;
      break;
    case 5:
      m_Parity = QSerialPort::MarkParity;
      break;
    default:
      m_Parity = QSerialPort::NoParity;
  }
}
