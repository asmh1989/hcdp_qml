cmake_minimum_required(VERSION 3.16)

project(hcdp VERSION 0.1 LANGUAGES CXX)

#set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


find_package(Qt6 6.2 REQUIRED COMPONENTS Quick Core Qml SerialPort)

add_subdirectory(Qt-AES)

set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/icon.rc")

qt_add_executable(apphcdp
    src/main.cpp
    ${app_icon_resource_windows}
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
    SOURCES src/utils.h src/utils.cpp
    SOURCES src/model.h
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
    QtAES
)

#target_link_libraries(apphcdp QtAES)

configure_file(${CMAKE_SOURCE_DIR}/data/data.json ${CMAKE_BINARY_DIR}/data/data.json COPYONLY)


include_directories(Qt-AES)

include(GNUInstallDirs)
install(TARGETS apphcdp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
