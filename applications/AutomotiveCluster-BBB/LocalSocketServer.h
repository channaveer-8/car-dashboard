#pragma once

#include <QObject>
#include <QLocalServer>
#include <QLocalSocket>
#include <QList>

class LocalSocketServer : public QObject
{
    Q_OBJECT
public:
    explicit LocalSocketServer(QObject *parent = nullptr);
    ~LocalSocketServer();

    bool startServer(const QString &socketPath = QStringLiteral("/home/debian/dashboard.sock"));

private slots:
    void onNewConnection();
    void onReadyRead();
    void onSocketDisconnected();

private:
    QLocalServer *m_server;
    QList<QLocalSocket*> m_clients;
};
