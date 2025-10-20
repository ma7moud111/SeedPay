#pragma once
#include "Settings.h"
#include <string>
#include <unordered_map>

class Localizer {
private:
    Settings &settings;
    std::unordered_map<std::string, std::unordered_map<Settings::Language, std::string>> translations;
    void initializeTranslations();
public:
    Localizer(Settings &s);
    std::string get(const std::string &key) const;
};
