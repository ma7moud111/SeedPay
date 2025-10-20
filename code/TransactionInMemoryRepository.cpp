#include "TransactionInMemoryRepository.h"

void TransactionInMemoryRepository::addTransaction(const TransactionDetails& tx) {
    transactions.push_back(tx);
}

std::vector<TransactionDetails> TransactionInMemoryRepository::getAllTransactions() const {
    return transactions;
}

std::vector<TransactionDetails> TransactionInMemoryRepository::getTransactionsByUser(const std::string& username) const {
    std::vector<TransactionDetails> userTransactions;
    for (const auto& tx : transactions) {
        if (tx.getUsername() == username) userTransactions.push_back(tx);
    }
    return userTransactions;
}
