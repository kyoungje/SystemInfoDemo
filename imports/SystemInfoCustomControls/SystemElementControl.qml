// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SystemInfoCustom


Pane {
    id: root

    property alias title: title.text
    property alias topLabel: topLabel.text
    property alias bottomLabel: bottomLabel.text

    topPadding: 20
    leftPadding: 16
    rightPadding: 16
    bottomPadding: 14

    width: 350
    height: 182

    background: Rectangle {
        radius: 12
        color: Constants.accentColor
        border.color: "transparent"
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: internal.columnSpacing

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: internal.rowSpacing

            Item {
                id: iconItem

                Layout.preferredWidth: icon.sourceSize.width
                Layout.preferredHeight: icon.sourceSize.height

                Image {
                    id: icon

                    source: "images/Screw@2x.png"
                }

                MultiEffect {
                    anchors.fill: icon
                    source: icon
                    colorization: 1
                    colorizationColor: Constants.iconColor
                }
            }

            Label {
                id: title

                text: qsTr("System Information")
                font.weight: 600
                font.pixelSize: 24
                font.family: "Titillium Web"
                color: Constants.primaryTextColor
                Layout.fillWidth: true
            }

        }

        Column {
            leftPadding: internal.infoLeftPadding
            spacing: internal.infoSpacing
            width: parent.width

            Label {
                id: topLabel

                text: qsTr("Top label")
                font.pixelSize: internal.infoFontSize
                font.bold: true
                font.family: "Titillium Web"
                color: Constants.primaryTextColor
            }


            Label {
                id: bottomLabel

                text: qsTr("Bottom label")
                font.pixelSize: internal.infoFontSize
                font.weight: 600
                font.family: "Titillium Web"
                color: Constants.primaryTextColor
            }

        }
    }

    QtObject {
        id: internal

        property int rowSpacing: 24
        property int columnSpacing: 24
        property int infoSpacing: 8
        property int infoFontSize: 14
        property int infoLeftPadding: 14
    }

}
