#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "DashboardAPI.h"
#include "LocalSocketServer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Create the DashboardAPI singleton before the engine loads QML
    DashboardAPI *api = DashboardAPI::instance();

    LocalSocketServer socketServer;
    socketServer.startServer();

    QQmlApplicationEngine engine;

    // Expose the singleton to all QML files as "DashboardAPI"
    engine.rootContext()->setContextProperty(QStringLiteral("DashboardAPI"), api);

    const QUrl url(u"qrc:/AutomotiveCluster/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
