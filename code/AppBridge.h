#pragma once
#include <QObject>
#include <QString>
#include <QStringList>
#include <vector>
#include <memory>
#include "TransactionService.h"

class ApplicationResources;
class TransactionService;

class AppBridge : public QObject {
    Q_OBJECT
public:
    explicit AppBridge(ApplicationResources *resources, QObject *parent = nullptr);
    ~AppBridge();

    Q_INVOKABLE bool login(const QString &username, const QString &password);
    Q_INVOKABLE bool registerUser(const QString &username, const QString &password);
    Q_INVOKABLE double getBalance() const;
    Q_INVOKABLE bool deposit(double amount);
    Q_INVOKABLE bool withdraw(double amount);
    Q_INVOKABLE bool payBill(double amount, const QString &billType);
    Q_INVOKABLE QStringList getTransactions() const; // CSV-ish lines for QML display
    Q_INVOKABLE QString currentUser() const;
    Q_INVOKABLE bool sendMoney(const QString &recipient, double amount);


signals:
    void loggedInChanged();
    void logUpdated(const QString &line);

private:
    ApplicationResources *m_resources;
    std::unique_ptr<TransactionService> m_txService;
    QString m_currentUser;
    void appendLog(const QString &line) const;
};
