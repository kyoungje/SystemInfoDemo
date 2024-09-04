

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SystemInfoCustom

Column {
    id: root

    property alias menuOptions: repeater.model
    required property var perfHistoryList

    leftPadding: internal.leftPadding
    spacing: internal.spacing

    Repeater {
        id: repeater
        model: menuOptions

        delegate: ItemDelegate {
            id: columnItem

            required property string name
            required property string view
            required property string iconSource

            readonly property bool active: Constants.currentView === columnItem.view

            width: column.width
            height: column.height

            background: Rectangle {
                color: active ? "#2CDE85" : "transparent"
                radius: Constants.isSmallLayout ? 4 : 12
                anchors.fill: parent
                opacity: Constants.isSmallLayout ? 0.3 : 0.1
            }

            Column {
                id: column
                padding: 0
                Item {
                    id: menuItem

                    width: internal.delegateWidth
                    height: internal.delegateHeight
                    visible: Constants.isSmallLayout == false
                             || columnItem.view != "SettingsView"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: internal.leftMargin
                        anchors.rightMargin: internal.rightMargin
                        spacing: 24

                        Item {
                            Layout.preferredWidth: internal.iconWidth
                            Layout.preferredHeight: internal.iconWidth
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            Image {
                                id: icon

                                source: "images/" + columnItem.iconSource
                                sourceSize.width: internal.iconWidth
                            }

                            MultiEffect {
                                anchors.fill: icon
                                source: icon
                                colorization: 1
                                colorizationColor: Constants.iconColor
                            }
                        }

                        Label {
                            id: menuItemName
                            text: name
                            font.family: "Titillium Web"
                            font.pixelSize: 18
                            font.weight: 600
                            Layout.fillWidth: true
                            visible: internal.isNameVisible
                            color: Constants.primaryTextColor
                        }

                        Image {
                            source: "images/arrow.svg"
                            visible: !columnItem.active
                                     && internal.isNameVisible
                        }
                    }
                }
            }

            Connections {
                function onClicked() {
                    if (columnItem.view != "SettingsView"
                            && columnItem.view != Constants.currentView) {
                        stackView.replace(columnItem.view + ".qml", {
                                                                    "perfHistoryList": perfHistoryList.get(0)
                                                                  }, StackView.Immediate)
                    }
                    Constants.currentView = columnItem.view
                }
            }

            Connections {
                target: sysInfoProvider

                function onMeasureCPUFreqEvent(result) {
                    var curValue = Math.trunc(result/1000000);
                    var perfStats = perfHistoryList.get(0);

                    perfStats.curIndex = (perfStats.curIndex + 1) % perfStats.maxCount;
                    perfStats.freqStats.set(perfStats.curIndex, {"freq": curValue});

                    // if "Server Sync" is enabled, send this performance data to the server
                    if (perfStats.sync)
                        window.sendPerfDataToServer(curValue);
                }
            }
        }
    }

    QtObject {
        id: internal

        property int delegateWidth: 290
        property int delegateHeight: 60
        property int iconWidth: 34
        property bool isNameVisible: true
        property int leftMargin: 5
        property int rightMargin: 13
        property int leftPadding: 5
        property int spacing: 5
    }
}
