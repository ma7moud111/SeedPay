#pragma once
#include "UserRepository.h"
#include <string>

class UserFileSystemRepository : public UserRepository {
private:
    std::string filePath;
    void initializeCSVFile();
    static inline std::string trim(const std::string &s) {
        const auto ws = " \t\r\n";
        size_t start = s.find_first_not_of(ws);
        if (start == std::string::npos) return std::string();
        size_t end = s.find_last_not_of(ws);
        return s.substr(start, end - start + 1);
    }
public:
    explicit UserFileSystemRepository(const std::string &path = "users.csv");
    bool authenticate(const std::string &username, const std::string &password) override;
    User* findByUsername(const std::string &username) override;
    void save(const User &user) override;
};
