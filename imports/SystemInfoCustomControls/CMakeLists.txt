# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

qt_add_library(SystemInfoCustomControls STATIC)
qt_add_qml_module(SystemInfoCustomControls
    URI "SystemInfoCustomControls"
    VERSION 1.0
    QML_FILES
        PerformanceChart.qml
        SystemElementControl.qml
    RESOURCES
        images/keyboard.svg
        images/thermometer.svg
        images/tooltip.svg
        images/Screw@2x.png
        images/LED@2x.png
        images/LED-Checked@2x.png
)

