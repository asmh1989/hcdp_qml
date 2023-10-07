#ifndef MODEL_H
#define MODEL_H

#include <QObject>
#include <QString>
#include <QGlobalStatic>

Q_GLOBAL_STATIC(const QString, globalReadOnlyKey, "1234567890abcdef");

struct SerialData {
    QString addr;
    QString code;
    QString data;
    QString name;
    QString quantity;
    QString time;
    bool circle;
};

#endif // MODEL_H
