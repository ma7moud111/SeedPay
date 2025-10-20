#include "ApplicationResources.h"
#include "Localizer.h"
#include "UserFileSystemRepository.h"
// #include "UserInMemoryRepository.h"
#include "TransactionFileSystemRepository.h"
#include "TransactionInMemoryRepository.h"

ApplicationResources::ApplicationResources() {
    localizer = std::make_unique<Localizer>(settings);
    if (settings.userRepoType == "InMemory")
        // userRepo = std::make_unique<UserInMemoryRepository>();
        userRepo = std::make_unique<UserFileSystemRepository>("users.csv");
    else userRepo = std::make_unique<UserFileSystemRepository>("users.csv");

    if (settings.txRepoType == "InMemory") transactionRepo = std::make_unique<TransactionInMemoryRepository>();
    else transactionRepo = std::make_unique<TransactionFileSystemRepository>("transactions.csv");
}

ApplicationResources::~ApplicationResources() = default;
