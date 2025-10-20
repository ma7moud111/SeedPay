#pragma once
#include "TransactionRepository.h"
#include <vector>

class TransactionInMemoryRepository : public TransactionRepository {
private:
    std::vector<TransactionDetails> transactions;
public:
    void addTransaction(const TransactionDetails& tx) override;
    std::vector<TransactionDetails> getAllTransactions() const override;
    std::vector<TransactionDetails> getTransactionsByUser(const std::string& username) const override;
};
