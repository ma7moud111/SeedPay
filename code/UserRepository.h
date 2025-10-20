#pragma once
#include <string>
#include "User.h"

class UserRepository {
public:
    virtual ~UserRepository() = default;
    virtual bool authenticate(const std::string &uname, const std::string &pass) = 0;
    virtual User* findByUsername(const std::string &uname) = 0; // returns new User* or nullptr; caller responsible to delete/wrap
    virtual void save(const User &user) = 0;
};
