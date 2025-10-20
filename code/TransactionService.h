#pragma once
#include "TransactionRepository.h"
#include <string>
#include <vector>
#include <memory>

class UserRepository;

class TransactionService {
private:
    TransactionRepository& repository;
    std::string currentUsername;
    UserRepository* userRepository;

public:
    explicit TransactionService(TransactionRepository& repo, const std::string& username, UserRepository* userRepo = nullptr);
    void deposit(double amount);
    void withdraw(double amount);
    void payBill(double amount, const std::string& billType);
    bool transferMoney(double amount, const std::string& recipientUsername);
    double getBalance() const;
    size_t getNumTransactions() const;
    std::vector<TransactionDetails> getTransactionsByUser() const;
};
