#include "TransactionFileSystemRepository.h"
#include <fstream>
#include <sstream>
#include <iostream>

TransactionFileSystemRepository::TransactionFileSystemRepository(const std::string& filename_) : filename(filename_) {
    initializeCSVFile();
}

void TransactionFileSystemRepository::initializeCSVFile() {
    std::ifstream testFile(filename);
    if (!testFile) {
        std::ofstream headerFile(filename);
        if (headerFile) headerFile << "type,amount,description,timestamp,status,username\n";
    }
}

void TransactionFileSystemRepository::addTransaction(const TransactionDetails& tx) {
    std::ofstream file(filename, std::ios::app);
    if (!file) { std::cerr << "Error: Could not open file " << filename << " for writing.\n"; return; }
    std::string description = tx.getDescription();
    if (description.find(',') != std::string::npos) description = "\"" + description + "\"";
    file << transactionTypeToString(tx.getType()) << ","
         << tx.getAmount() << ","
         << description << ","
         << tx.getTimestamp() << ","
         << tx.getStatus() << ","
         << tx.getUsername() << "\n";
    if (!file) std::cerr << "Error: Failed to write transaction to file.\n";
}

std::vector<TransactionDetails> TransactionFileSystemRepository::getAllTransactions() const {
    std::vector<TransactionDetails> transactions;
    std::ifstream file(filename);
    if (!file) return transactions;
    std::string line;
    bool isFirstLine = true;
    while (std::getline(file, line)) {
        if (isFirstLine) { isFirstLine = false; continue; }
        if (line.empty()) continue;
        try {
            std::vector<std::string> tokens = parseCSVLine(line);
            if (tokens.size() >= 6) {
                TransactionType type = stringToTransactionType(tokens[0]);
                double amount = std::stod(tokens[1]);
                std::string description = tokens[2];
                std::time_t timestamp = static_cast<std::time_t>(std::stol(tokens[3]));
                std::string status = tokens[4];
                std::string username = tokens[5];
                transactions.emplace_back(type, amount, description, timestamp, status, username);
            }
        } catch (const std::exception& e) {
            std::cerr << "Error parsing transaction line: " << line << " - " << e.what() << "\n";
        }
    }
    if (!file.eof() && file.fail()) std::cerr << "Error reading from file " << filename << "\n";
    return transactions;
}

std::vector<TransactionDetails> TransactionFileSystemRepository::getTransactionsByUser(const std::string& username) const {
    std::vector<TransactionDetails> userTransactions;
    auto allTransactions = getAllTransactions();
    for (const auto& tx : allTransactions) {
        if (tx.getUsername() == username) userTransactions.push_back(tx);
    }
    return userTransactions;
}

std::vector<std::string> TransactionFileSystemRepository::parseCSVLine(const std::string& line) const {
    std::vector<std::string> tokens;
    std::stringstream ss(line);
    std::string token;
    bool inQuotes = false;
    for (size_t i = 0; i < line.length(); ++i) {
        char c = line[i];
        if (c == '"') { inQuotes = !inQuotes; }
        else if (c == ',' && !inQuotes) {
            token.erase(0, token.find_first_not_of(" \t\r\n"));
            token.erase(token.find_last_not_of(" \t\r\n") + 1);
            tokens.push_back(token);
            token.clear();
        } else token += c;
    }
    if (!token.empty()) {
        token.erase(0, token.find_first_not_of(" \t\r\n"));
        token.erase(token.find_last_not_of(" \t\r\n") + 1);
        tokens.push_back(token);
    }
    return tokens;
}
