#include "LocalSocketServer.h"
#include "DashboardAPI.h"
#include <QFile>
#include <QDebug>

LocalSocketServer::LocalSocketServer(QObject *parent)
    : QObject(parent), m_server(new QLocalServer(this))
{
    connect(m_server, &QLocalServer::newConnection, this, &LocalSocketServer::onNewConnection);
}

LocalSocketServer::~LocalSocketServer()
{
    m_server->close();
}

bool LocalSocketServer::startServer(const QString &socketPath)
{
    // Clean up any existing socket file
    QFile::remove(socketPath);
    if (!m_server->listen(socketPath)) {
        qWarning() << "Failed to start local socket server:" << m_server->errorString();
        return false;
    }
    qDebug() << "Local socket server listening on" << socketPath;
    return true;
}

void LocalSocketServer::onNewConnection()
{
    while (m_server->hasPendingConnections()) {
        QLocalSocket *clientSocket = m_server->nextPendingConnection();
        if (!clientSocket) continue;

        connect(clientSocket, &QLocalSocket::readyRead, this, &LocalSocketServer::onReadyRead);
        connect(clientSocket, &QLocalSocket::disconnected, this, &LocalSocketServer::onSocketDisconnected);
        m_clients.append(clientSocket);
        qDebug() << "Client connected to local socket server.";
    }
}

void LocalSocketServer::onReadyRead()
{
    QLocalSocket *clientSocket = qobject_cast<QLocalSocket*>(sender());
    if (!clientSocket) return;

    // Read all available text data from the socket
    QByteArray data = clientSocket->readAll();
    qDebug() << "Raw data received on socket:" << data;
    QString text = QString::fromUtf8(data);

    // Replace literal backslash-n and backslash-r with actual newlines/carriagereturns
    text.replace(QStringLiteral("\\n"), QStringLiteral("\n"));
    text.replace(QStringLiteral("\\r"), QStringLiteral("\r"));

    // Split by real newlines to process commands individually
    QStringList lines = text.split(QChar('\n'));

    for (const QString &rawLine : lines) {
        QString line = rawLine.trimmed();
        if (line.isEmpty()) continue;

        // Commands must be in "key:value" format
        int colonIdx = line.indexOf(':');
        if (colonIdx == -1) {
            qDebug() << "Command missing colon:" << line;
            continue;
        }

        QString key = line.left(colonIdx).trimmed().toLower();
        QString valStr = line.mid(colonIdx + 1).trimmed();
        qDebug() << "Parsed command key:" << key << "valStr:" << valStr;

        DashboardAPI *api = DashboardAPI::instance();
        if (!api) continue;

        bool ok;
        double valDouble = valStr.toDouble(&ok);
        bool valBool = (valStr == QStringLiteral("1") || valStr.toLower() == QStringLiteral("true"));

        if (key == QStringLiteral("throttle") && ok) {
            api->setThrottle(valDouble);
        } else if (key == QStringLiteral("battery") && ok) {
            api->setBattery(valDouble);
        } else if (key == QStringLiteral("temp") && ok) {
            api->setTemperature(valDouble);
        } else if (key == QStringLiteral("gear")) {
            api->setGear(valStr.toUpper());
        } else if (key == QStringLiteral("doorl")) {
            api->setLeftDoorOpen(valBool);
        } else if (key == QStringLiteral("doorr")) {
            api->setRightDoorOpen(valBool);
        } else if (key == QStringLiteral("brake")) {
            api->setBrakePressed(valBool);
        } else if (key == QStringLiteral("highbeam")) {
            api->setHighBeam(valBool);
        } else if (key == QStringLiteral("seatbelt")) {
            api->setSeatbeltWarning(valBool);
        } else if (key == QStringLiteral("abs")) {
            api->setAbsWarning(valBool);
        } else if (key == QStringLiteral("fault")) {
            api->setElectricalFault(valBool);
        } else if (key == QStringLiteral("tire")) {
            api->setTirePressureLow(valBool);
        } else if (key == QStringLiteral("cruise")) {
            api->setCruiseControlActive(valBool);
        } else if (key == QStringLiteral("indl")) {
            api->setLeftIndicator(valBool);
        } else if (key == QStringLiteral("indr")) {
            api->setRightIndicator(valBool);
        } else {
            qWarning() << "Unknown local socket command:" << key << "with value:" << valStr;
        }
    }
}

void LocalSocketServer::onSocketDisconnected()
{
    QLocalSocket *clientSocket = qobject_cast<QLocalSocket*>(sender());
    if (!clientSocket) return;

    m_clients.removeOne(clientSocket);
    clientSocket->deleteLater();
    qDebug() << "Client disconnected from local socket server.";
}
