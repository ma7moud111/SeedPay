#include "TransactionService.h"
#include "TransactionDetails.h"
#include "TransactionType.h"
#include "UserRepository.h"
#include <ctime>
#include <iostream>

TransactionService::TransactionService(TransactionRepository& repo, const std::string& username, UserRepository* userRepo)
    : repository(repo), currentUsername(username), userRepository(userRepo) {}

void TransactionService::deposit(double amount) {
    std::time_t now = std::time(nullptr);
    TransactionDetails tx(TransactionType::Deposit, amount, "Deposit transaction", now, "Completed", currentUsername);
    repository.addTransaction(tx);
}

void TransactionService::withdraw(double amount) {
    if (getBalance() >= amount) {
        std::time_t now = std::time(nullptr);
        TransactionDetails tx(TransactionType::Withdrawal, amount, "Withdrawal transaction", now, "Completed", currentUsername);
        repository.addTransaction(tx);
    }
}

void TransactionService::payBill(double amount, const std::string& billType) {
    if (getBalance() >= amount) {
        std::time_t now = std::time(nullptr);
        TransactionDetails tx(TransactionType::BillPayment, amount, billType + " bill payment", now, "Completed", currentUsername);
        repository.addTransaction(tx);
    }
}

bool TransactionService::transferMoney(double amount, const std::string& recipientUsername) {
    if (!userRepository) return false;
    if (recipientUsername == currentUsername) return false;

    std::unique_ptr<User> recipient(userRepository->findByUsername(recipientUsername));
    if (!recipient) return false;
    if (getBalance() < amount) return false;

    std::time_t now = std::time(nullptr);

    // Sender transaction (TransferOut)
    TransactionDetails senderTx(
        TransactionType::TransferOut,
        amount,
        "Transfer to " + recipientUsername,
        now,
        "Completed",
        currentUsername
        );
    repository.addTransaction(senderTx);

    // Recipient transaction (TransferIn)
    TransactionDetails recipientTx(
        TransactionType::TransferIn,
        amount,
        "Transfer from " + currentUsername,
        now,
        "Completed",
        recipientUsername
        );
    repository.addTransaction(recipientTx);

    return true;
}


double TransactionService::getBalance() const {
    double bal = 0.0;
    auto txs = repository.getTransactionsByUser(currentUsername);
    for (const auto &t : txs) {
        switch (t.getType()) {
        case TransactionType::Deposit:
        case TransactionType::TransferIn:
            bal += t.getAmount();
            break;
        case TransactionType::Withdrawal:
        case TransactionType::BillPayment:
        case TransactionType::TransferOut:
            bal -= t.getAmount();
            break;
        }
    }
    return bal;
}


size_t TransactionService::getNumTransactions() const {
    return repository.getTransactionsByUser(currentUsername).size();
}

std::vector<TransactionDetails> TransactionService::getTransactionsByUser() const {
    return repository.getTransactionsByUser(currentUsername);
}
