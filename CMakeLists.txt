# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

cmake_minimum_required(VERSION 3.16)

project(SystemInfoClient LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Gui Qml Quick QuickControls2 Svg Charts)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(SystemInfoClient src/main.cpp)

qt_add_resources(SystemInfoClient "configuration"
    PREFIX "/"
    FILES
        qtquickcontrols2.conf
)

include(qmlmodules)

target_link_libraries(SystemInfoClient PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
    Qt6::Svg
    Qt6::Charts
    Qt6::QuickControls2
)

install(TARGETS SystemInfoClient
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET SystemInfoClient
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
