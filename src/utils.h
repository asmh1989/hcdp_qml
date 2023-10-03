#ifndef UTILS_H
#define UTILS_H

#include <QObject>

class utils
{
public:
    utils();

    static QByteArray encode(QString addr, QString code, QString data, bool circle = false);
};

#endif // UTILS_H
