#pragma once
#include "TransactionRepository.h"
#include <string>
#include <vector>

class TransactionFileSystemRepository : public TransactionRepository {
private:
    std::string filename;
    void initializeCSVFile();
    std::vector<std::string> parseCSVLine(const std::string& line) const;
public:
    explicit TransactionFileSystemRepository(const std::string& filename = "transactions.csv");
    void addTransaction(const TransactionDetails& tx) override;
    std::vector<TransactionDetails> getAllTransactions() const override;
    std::vector<TransactionDetails> getTransactionsByUser(const std::string& username) const override;
};
