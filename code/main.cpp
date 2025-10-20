#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "AppBridge.h"
#include "ApplicationResources.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<AppBridge>("SeedPay", 1, 0, "AppBridge");

    ApplicationResources *resources = new ApplicationResources();

    QQmlApplicationEngine engine;
    // Expose resources via context property too (optional)
    AppBridge *bridge = new AppBridge(resources);
    engine.rootContext()->setContextProperty("AppBridgeInstance", bridge);

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl) QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
