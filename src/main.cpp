// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "app_environment.h"
#include "import_qml_plugins.h"
#include "sysinfoprovider.h"

int main(int argc, char *argv[])
{
    set_qt_environment();
    QApplication app(argc, argv);
    QApplication::setApplicationName("SystemInfoClient");
    QApplication::setOrganizationName("QtProject");

    QQmlApplicationEngine engine;

    // exposing C++ object to Qml
    SysInfoProvider *sysInfo = new SysInfoProvider(&app);
    engine.rootContext()->setContextProperty("sysInfoProvider", sysInfo);

    QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, &QGuiApplication::quit);
    engine.loadFromModule("Main", "Main");

    return app.exec();
}
