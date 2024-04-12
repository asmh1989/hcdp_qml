#include "utils.h"

#include <QDateTime>
#include <QDebug>

#include "model.h"
#include "qaesencryption.h"

utils::utils() {}

QString utils::formatQByte(const QByteArray &array) {
  QString data_with_crc_hex;
  for (char byte : array) {
    data_with_crc_hex.append(
        QString("%1 ")
            .arg(static_cast<quint8>(byte), 2, 16, QLatin1Char('0'))
            .toUpper());
  }
  return data_with_crc_hex.trimmed();
}

QByteArray utils::calculate_modbus_crc(const QByteArray &data) {
  uint16_t crc = 0xFFFF;
  for (char byte : data) {
    crc ^= static_cast<uint8_t>(byte);
    for (int j = 0; j < 8; ++j) {
      if (crc & 1) {
        crc = (crc >> 1) ^ 0xA001;  // 0x18005反转后的值
      } else {
        crc >>= 1;
      }
    }
  }

  QByteArray crcBytes;
  crcBytes.append(static_cast<char>((crc >> 8) & 0xFF));  // High byte
  crcBytes.append(static_cast<char>(crc & 0xFF));         // Low byte

  return data + crcBytes;
}

QByteArray _encode(QByteArray data) {
  //    QByteArray data = QByteArray::fromHex("3005000B63A721FF20010001000118");
  qDebug() << "Ori:" << utils::formatQByte(data);
  QByteArray crcData = utils::calculate_modbus_crc(data);

  qDebug() << "crc:" << utils::formatQByte(crcData);

  // Encrypt data using AES in ECB mode
  QAESEncryption encryption(QAESEncryption::AES_128, QAESEncryption::ECB,
                            QAESEncryption::PKCS7);

  QByteArray encryptedData =
      encryption.encode(crcData, globalReadOnlyKey->toUtf8());
  qDebug() << "aes: " << utils::formatQByte(encryptedData);

  // Encode the encrypted data using base64 encoding
  QByteArray base64Data = encryptedData.toBase64();
  qDebug() << "base64: " << QString(base64Data);

  // Prepare final data packet
  QByteArray finalData = "$" + base64Data + "\r";
  qDebug() << "Final Data:" << finalData;

  return finalData;
}

QByteArray utils::convertQStringToByteArray(const QString &input) {
  QByteArray result;
  const int length = input.length();

  for (int i = 0; i < length; i += 2) {
    QString byteStr = input.mid(i, 2);
    bool ok = false;
    char byte = static_cast<char>(byteStr.toInt(&ok, 16));
    if (ok) {
      result.append(byte);
    } else {
      // Handle invalid input or odd-length input
      qWarning() << "Invalid input format or odd-length input";
      break;
    }
  }

  return result;
}

QString utils::get_time() {
  QDateTime currentDateTime = QDateTime::currentDateTime();
  uint32_t time =
      static_cast<uint32_t>(currentDateTime.toMSecsSinceEpoch() / 1000);

  return QString("%1").arg(time, 4, 16, QLatin1Char('0')).toUpper();
}

QByteArray utils::encode(QString addr, QString code, QString data,
                         bool circle) {
  auto time = get_time();
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
  s_data.append(get_time());
  // 数据
  s_data.append(data);

  auto s_byte = convertQStringToByteArray(s_data);

  return _encode(s_byte);
}
