#pragma once
#include <string>

class Settings {
public:
    enum class Language { English, Deutsch };
    Language language = Language::English;
    std::string userRepoType = "FileSystem";
    std::string txRepoType = "FileSystem";

    void setLanguage(const std::string &lang) {
        if (lang == "Deutsch") language = Language::Deutsch;
        else language = Language::English;
    }
};
