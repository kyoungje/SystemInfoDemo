// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick 6.7
import SystemInfoCustom

Window {
    id: window

    width: Constants.width
    height: Constants.height

    minimumHeight: 272

    visible: true
    title: "SystemInfoCustom"

    Home {
        id: mainScreen
        anchors.fill: parent
    }

    Component.onCompleted: function() {
        Constants.isBigDesktopLayout = Qt.binding( function(){
            return window.width >= Constants.width && window.width >= window.height
        })
        Constants.isSmallDesktopLayout = Qt.binding( function(){
            return window.width >= 647 && window.width < Constants.width && window.width >= window.height
        })
        Constants.isMobileLayout = Qt.binding( function(){
            return window.width < window.height
        })
        Constants.isSmallLayout = Qt.binding( function(){
            return window.width < 647 && window.width >= window.height
        })
    }
}

