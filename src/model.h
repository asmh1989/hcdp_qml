#ifndef MODEL_H
#define MODEL_H

#include <QObject>

struct SerialData {
    QString addr;
    QString code;
    QString data;
    QString name;
    bool circle;
};

#endif // MODEL_H
