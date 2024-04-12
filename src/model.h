#ifndef MODEL_H
#define MODEL_H

#include <QDateTime>
#include <QGlobalStatic>
#include <QJsonObject>
#include <QObject>
#include <QString>

Q_GLOBAL_STATIC(const QString, globalReadOnlyKey, "1234567890abcdef");

struct SerialData {
  QString fmCls;
  QString dstAddr;
  QString srcAddr;
  QString fmLen;
  QString dgTag;
  QString dstPt;
  QString srcPt;
  QString dgLen;
  QString Data;
  QString time;
  QString crc;
  QString error;

  // 构造函数，设置 time 为当前时间的格式化字符串
  SerialData() {
    time = QDateTime::currentDateTime().time().toString("hh:mm:ss.zzz");
  }

  // 赋值操作符重载函数，实现深度拷贝
  SerialData &operator=(const SerialData &other) {
    if (this != &other) {  // 避免自赋值
      fmCls = other.fmCls;
      dstAddr = other.dstAddr;
      srcAddr = other.srcAddr;
      fmLen = other.fmLen;
      dgTag = other.dgTag;
      dstPt = other.dstPt;
      srcPt = other.srcPt;
      dgLen = other.dgLen;
      Data = other.Data;
      time = other.time;
      error = other.error;
      crc = other.crc;
    }
    return *this;
  }

  // 定义比较操作符
  bool operator==(const SerialData &other) const {
    return fmCls == other.fmCls && dstAddr == other.dstAddr &&
           srcAddr == other.srcAddr && fmLen == other.fmLen &&
           dgTag == other.dgTag && dstPt == other.dstPt &&
           srcPt == other.srcPt && dgLen == other.dgLen && Data == other.Data &&
           time == other.time;
  }

  bool operator!=(const SerialData &other) const { return !(*this == other); }

  QJsonObject toJson() const {
    QJsonObject obj;
    obj["fmCls"] = fmCls;
    obj["dstAddr"] = dstAddr;
    obj["srcAddr"] = srcAddr;
    obj["fmLen"] = fmLen;
    obj["dgTag"] = dgTag;
    obj["dstPt"] = dstPt;
    obj["srcPt"] = srcPt;
    obj["dgLen"] = dgLen;
    obj["Data"] = Data;
    obj["time"] = time;
    obj["error"] = error;
    obj["crc"] = crc;
    return obj;
  }

  static SerialData fromJson(const QJsonObject &obj) {
    SerialData data;
    data.fmCls = obj["fmCls"].toString();
    data.dstAddr = obj["dstAddr"].toString();
    data.srcAddr = obj["srcAddr"].toString();
    data.fmLen = obj["fmLen"].toString();
    data.dgTag = obj["dgTag"].toString();
    data.dstPt = obj["dstPt"].toString();
    data.srcPt = obj["srcPt"].toString();
    data.dgLen = obj["dgLen"].toString();
    data.Data = obj["Data"].toString();
    data.time = obj["time"].toString();
    data.error = obj["error"].toString();
    data.crc = obj["crc"].toString();

    return data;
  }
};
#endif  // MODEL_H
