# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

qt_add_library(SystemInfoContent STATIC)
qt_add_qml_module(SystemInfoContent
    URI "SystemInfoContent"
    VERSION 1.0
    QML_FILES
        App.qml
        Home.qml
        HomeForm.ui.qml
        HomeView.qml
        HomeViewForm.ui.qml
        PerformanceView.qml
        PerformanceViewForm.ui.qml
        SideBar.qml
        SideBarForm.ui.qml



    RESOURCES
        images/arrow.svg
        images/Auto.svg
        images/bedroom.svg
        images/circle.svg
        images/Cool.svg
        images/down.svg
        images/drop.svg
        images/Dry.svg
        images/Eco.svg
        images/edit.svg
        images/energy.svg
        images/Fan.svg
        images/Heat.svg
        images/home.svg
        images/kid_room.svg
        images/kitchen.svg
        images/living_room.svg
        images/logo.png
        images/maxTemp.svg
        images/minTemp.svg
        images/more.svg
        images/power.svg
        images/schedule.svg
        images/settings.svg
        images/stats.svg
        images/temperature.svg
        images/theme.svg
        images/thermostat.svg
        images/up.svg
)
