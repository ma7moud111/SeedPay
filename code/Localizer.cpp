#include "Localizer.h"

Localizer::Localizer(Settings &s) : settings(s) { initializeTranslations(); }

void Localizer::initializeTranslations() {
    translations["welcome_title"] = {{Settings::Language::English, "Welcome to SeedPay"}, {Settings::Language::Deutsch, "Willkommen bei SeedPay"}};
}

std::string Localizer::get(const std::string &key) const {
    auto it = translations.find(key);
    if (it != translations.end()) {
        auto lit = it->second.find(settings.language);
        if (lit != it->second.end()) return lit->second;
    }
    return key;
}
