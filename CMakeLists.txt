cmake_minimum_required(VERSION 3.16)

project(hcdp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick Core Qml SerialPort)


qt_add_executable(apphcdp
    src/main.cpp
)

qt_add_qml_module(apphcdp
    URI hcdp
    VERSION 1.0
    QML_FILES qml/Main.qml
    QML_FILES qml/Header.qml
    QML_FILES qml/GrayLabel.qml
    QML_FILES qml/HcdpContent.qml
    QML_FILES qml/HcdpInput.qml
    QML_FILES qml/Footer.qml
    SOURCES src/singletonmanager.h src/singletonmanager.cpp
    QML_FILES qml/ToastManager.qml
    QML_FILES qml/Toast.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(apphcdp PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apphcdp
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(apphcdp
    PRIVATE Qt6::Quick
    Qt6::Core
    Qt6::Qml
    Qt6::SerialPort
)

include(GNUInstallDirs)
install(TARGETS apphcdp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
