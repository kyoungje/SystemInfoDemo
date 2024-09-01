// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import SystemInfoCustom

Switch {
    id: control

    readonly property color gradientColor1: "#FFFFFF"
    readonly property color gradientColor2: "#002125"

    indicator: Rectangle {
        anchors.right: parent.right
        implicitWidth: internal.indicatorWidth
        implicitHeight: internal.indicatorHeight
        radius: 12
        border.color: "#898989"

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: !control.checked ? control.gradientColor1 : "#2CDE85"
            }
            GradientStop {
                position: 1.0
                color: !control.checked ? control.gradientColor2 : "#2CDE85"
            }
        }

        Rectangle {
            width: 1
            height: internal.separatorHeight
            anchors.verticalCenter: parent.verticalCenter
            x: control.checked ? internal.separatorStartPos : internal.separatorEndPos
            color: "#898989"
        }

        Rectangle {
            id: circle

            anchors.verticalCenter: parent.verticalCenter
            x: control.checked ? parent.width - width - 2 : 2
            width: internal.circleSize
            height: internal.circleSize
            radius: 10
            color: "#ffffff"
            border.color: "#898989"

            Behavior on x  {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutBack
                }
            }
        }
    }

    QtObject {
        id: internal

        property int circleSize: 20
        property int indicatorWidth: 55
        property int indicatorHeight: 24
        property int separatorHeight: 9
        property int separatorStartPos: 20
        property int separatorEndPos: 35
    }
}
