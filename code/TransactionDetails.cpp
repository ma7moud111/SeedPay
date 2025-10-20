#include "TransactionDetails.h"
#include <sstream>

TransactionDetails::TransactionDetails(TransactionType t, double a, const std::string& d, std::time_t ts, const std::string& s, const std::string& user)
    : type(t), amount(a), description(d), timestamp(ts), status(s), username(user) {}

std::string TransactionDetails::getDetails() const {
    std::stringstream ss;
    ss << transactionTypeToString(type) << "," << amount << "," << description << "," << timestamp << "," << status << "," << username;
    return ss.str();
}
