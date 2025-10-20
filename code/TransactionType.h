#pragma once
#include <string>

enum class TransactionType {
    Deposit,
    Withdrawal,
    BillPayment,
    TransferOut,
    TransferIn
};

const char* transactionTypeToString(TransactionType type);
TransactionType stringToTransactionType(const std::string &str);
