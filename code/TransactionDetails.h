#pragma once
#include <string>
#include <ctime>
#include "TransactionType.h"

class TransactionDetails {
private:
    TransactionType type;
    double amount;
    std::string description;
    std::time_t timestamp;
    std::string status;
    std::string username;

public:
    TransactionDetails() = default;
    TransactionDetails(TransactionType t, double a, const std::string& d, std::time_t ts, const std::string& s, const std::string& user);
    std::string getDetails() const;

    TransactionType getType() const { return type; }
    double getAmount() const { return amount; }
    const std::time_t& getTimestamp() const { return timestamp; }
    const std::string& getStatus() const { return status; }
    const std::string& getDescription() const { return description; }
    const std::string& getUsername() const { return username; }
};
