#ifndef UTILS_H
#define UTILS_H

#include <QObject>

class utils {
 private:
  utils();

 public:
  static QByteArray encode(QString addr, QString code, QString data,
                           bool circle = false);
  static QString formatQByte(const QByteArray &array);
  static QByteArray calculate_modbus_crc(const QByteArray &data);
  static QByteArray convertQStringToByteArray(const QString &input);
  static QString get_time();
};

#endif  // UTILS_H
