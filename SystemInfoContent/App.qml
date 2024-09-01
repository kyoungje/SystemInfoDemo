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
    title: "System Information and Performance Client"

    Home {
        id: mainScreen
        anchors.fill: parent

        Component.onCompleted: function() {
            var perfStats = perfHistoryList.get(0);

            for (let i = 0; i < perfStats.maxCount; ++i) {
                perfStats.freqStats.append({"freq": 0});
            }

            perfStats.curIndex = perfStats.maxCount-1;
        }
    }
}

