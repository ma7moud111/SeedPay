#include "AppBridge.h"
#include "ApplicationResources.h"
#include "TransactionService.h"
#include "UserRepository.h"
#include <memory>
#include <QStringList>
#include <ctime>

AppBridge::AppBridge(ApplicationResources *resources, QObject *parent)
    : QObject(parent), m_resources(resources)
{
}

AppBridge::~AppBridge() = default;

bool AppBridge::login(const QString &username, const QString &password)
{
    if (!m_resources) return false;
    auto &repo = m_resources->getUserRepository();
    bool ok = repo.authenticate(username.toStdString(), password.toStdString());
    if (ok) {
        m_currentUser = username;
        m_txService = std::make_unique<TransactionService>(
            m_resources->getTransactionRepository(),
            username.toStdString(),
            &m_resources->getUserRepository());
        emit loggedInChanged();
        appendLog(QString("Logged in: %1").arg(username));
    }
    return ok;
}

bool AppBridge::registerUser(const QString &username, const QString &password)
{
    if (!m_resources) return false;
    auto &repo = m_resources->getUserRepository();
    std::unique_ptr<User> existing(repo.findByUsername(username.toStdString()));
    if (existing) return false; // already exists
    User u(username.toStdString(), password.toStdString());
    repo.save(u);
    appendLog(QString("Registered: %1").arg(username));
    return true;
}

double AppBridge::getBalance() const
{
    if (!m_txService) return 0.0;
    return m_txService->getBalance();
}

bool AppBridge::deposit(double amount)
{
    if (!m_txService) return false;
    m_txService->deposit(amount);
    appendLog(QString("Deposited: %1").arg(amount));
    return true;
}

bool AppBridge::withdraw(double amount)
{
    if (!m_txService) return false;
    m_txService->withdraw(amount);
    appendLog(QString("Withdrew: %1").arg(amount));
    return true;
}

bool AppBridge::payBill(double amount, const QString &billType)
{
    if (!m_txService) return false;
    m_txService->payBill(amount, billType.toStdString());
    appendLog(QString("Paid bill (%1): %2").arg(billType).arg(amount));
    return true;
}

bool AppBridge::sendMoney(const QString &recipient, double amount)
{
    if (!m_txService) return false;

    bool ok = m_txService->transferMoney(amount, recipient.toStdString());
    if (ok) {
        appendLog(QString("Sent %1 EGP to %2").arg(amount).arg(recipient));
    } else {
        appendLog(QString("Failed to send %1 EGP to %2").arg(amount).arg(recipient));
    }
    return ok;
}

QStringList AppBridge::getTransactions() const
{
    QStringList list;
    if (!m_txService) return list;

    auto &repo = m_resources->getTransactionRepository();
    auto v = repo.getTransactionsByUser(m_currentUser.toStdString());

    for (const auto &t : v) {
        char buf[26];
        ctime_r(&t.getTimestamp(), buf);
        buf[24] = '\0';
        QString line = QString("%1 | %2 | %3 EGP | %4")
                           .arg(QString::fromStdString(buf))
                           .arg(QString::fromStdString(transactionTypeToString(t.getType())))
                           .arg(t.getAmount())
                           .arg(QString::fromStdString(t.getDescription()));
        list << line;
    }

    return list;
}

QString AppBridge::currentUser() const
{
    return m_currentUser;
}

void AppBridge::appendLog(const QString &line) const
{
    const_cast<AppBridge*>(this)->logUpdated(line);
}
