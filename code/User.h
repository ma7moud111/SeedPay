#pragma once
#include <string>

class User {
private:
    std::string username;
    std::string password;
public:
    User() = default;
    User(const std::string &u, const std::string &p) : username(u), password(p) {}
    const std::string &getUsername() const { return username; }
    const std::string &getPassword() const { return password; }
};
