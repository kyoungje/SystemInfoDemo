// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick

ListModel {
    id: perfHistoryList

    ListElement {
        name: qsTr("CPU Frequency")
        active: false
        sync: false
        maxCount: 60
        curIndex: 0
        freqStats: [

        ]
    }
}
