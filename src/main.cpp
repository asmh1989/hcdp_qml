#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "singletonmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);



    QQmlApplicationEngine engine;
    // 注册C++对象到QML引擎
    engine.rootContext()->setContextProperty("sm", SingletonManager::instance());

    // 设置C++对象的所有权为QQmlEngine::CppOwnership
    engine.setObjectOwnership(SingletonManager::instance(), QQmlEngine::CppOwnership);


    const QUrl url(u"qrc:/hcdp/qml/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
