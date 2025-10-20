#include "UserFileSystemRepository.h"
#include <fstream>
#include <sstream>
#include <iostream>

UserFileSystemRepository::UserFileSystemRepository(const std::string &path) : filePath(path) {
    initializeCSVFile();
}

void UserFileSystemRepository::initializeCSVFile() {
    std::ifstream testFile(filePath);
    if (!testFile) {
        std::ofstream headerFile(filePath);
        if (headerFile) headerFile << "username,password\n";
    }
}

bool UserFileSystemRepository::authenticate(const std::string &username, const std::string &password) {
    std::ifstream file(filePath);
    if (!file) return false;
    std::string line;
    bool isFirst = true;
    while (std::getline(file, line)) {
        if (isFirst) { isFirst = false; continue; }
        if (line.empty()) continue;
        std::stringstream ss(line);
        std::string storedUsername, storedPassword;
        if (std::getline(ss, storedUsername, ',') && std::getline(ss, storedPassword)) {
            storedUsername = trim(storedUsername);
            storedPassword = trim(storedPassword);
            if (storedUsername == username && storedPassword == password) return true;
        }
    }
    return false;
}

User* UserFileSystemRepository::findByUsername(const std::string &username) {
    std::ifstream file(filePath);
    if (!file) return nullptr;
    std::string line;
    bool isFirst = true;
    while (std::getline(file, line)) {
        if (isFirst) { isFirst = false; continue; }
        if (line.empty()) continue;
        std::stringstream ss(line);
        std::string storedUsername, storedPassword;
        if (std::getline(ss, storedUsername, ',') && std::getline(ss, storedPassword)) {
            storedUsername = trim(storedUsername);
            storedPassword = trim(storedPassword);
            if (storedUsername == username) {
                return new User(storedUsername, storedPassword);
            }
        }
    }
    return nullptr;
}

void UserFileSystemRepository::save(const User &user) {
    std::ofstream file(filePath, std::ios::app);
    if (!file) { std::cerr << "Could not open user file for writing\n"; return; }
    file << user.getUsername() << "," << user.getPassword() << "\n";
}
