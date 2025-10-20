cmake_minimum_required(VERSION 3.16)

project(seedpayqml VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

# --- Executable target ---
qt_add_executable(appseedpayqml
    main.cpp
)

# --- QML module and resources ---
qt_add_qml_module(appseedpayqml
    URI qml                          #  match your resource prefix
    VERSION 1.0
    QML_FILES
        Main.qml
        SplashScreen.qml
        LoginPage.qml
        RegisterPage.qml
        DashboardPage.qml
        TransactionRow.qml
    SOURCES
        AppBridge.h AppBridge.cpp
        Settings.h
        ApplicationResources.h ApplicationResources.cpp
        Localizer.h Localizer.cpp
        User.h
        UserRepository.h
        UserFileSystemRepository.h UserFileSystemRepository.cpp
        TransactionType.h TransactionType.cpp
        TransactionDetails.h TransactionDetails.cpp
        TransactionRepository.h
        TransactionFileSystemRepository.h TransactionFileSystemRepository.cpp
        TransactionInMemoryRepository.h TransactionInMemoryRepository.cpp
        TransactionService.h TransactionService.cpp
    RESOURCES
        resources.qrc
)

# --- App properties ---
set_target_properties(appseedpayqml PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

# --- Link libraries ---
target_link_libraries(appseedpayqml
    PRIVATE
        Qt6::Quick
)

# --- Install rules ---
include(GNUInstallDirs)
install(TARGETS appseedpayqml
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
