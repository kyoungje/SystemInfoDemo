

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SystemInfoCustom
import SystemInfoCustomControls

Page {
    id: root

    property alias perfHistoryList: perfHistoryList

    background: Rectangle {
        color: Constants.accentColor
    }

    component DeviceText: Text{
        color: Constants.primaryTextColor
        font.family: Constants.desktopSubtitleFont.family
        font.weight: Constants.desktopSubtitleFont.weight
        font.pixelSize: 9
    }

    component SwitchImage: Image {
        required property string sourceBaseName
        property bool checked

        source: `images/${sourceBaseName}${checked? "-Checked" : ""}.png`
    }

    component DeviceSwitch: SwitchImage {
        property alias topMargin: tapHandler.margin
        TapHandler {
            id: tapHandler
            onTapped: parent.checked = !parent.checked
        }
    }

    SwitchImage {
        id: ledImage
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 30
        sourceBaseName: "LED"
        checked: startSync.checked

        DeviceText {
            text: qsTr("Server Sync")
            anchors.top: parent.bottom
            anchors.topMargin: 4
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    CustomSwitch {
        id: startSync
        checked: false
        anchors.left: ledImage.left
        anchors.top: ledImage.top
        anchors.leftMargin: 30
    }

    StackView {
        id: stackView

        anchors.left: sideMenu.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        initialItem: HomeView {
            perfHistoryList: perfHistoryList
        }
    }

    SideBar {
        id: sideMenu

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 63
        height: parent.height

        menuOptions: menuItems
        perfHistoryList: perfHistoryList
    }

    PerfHistoryModel {
        id: perfHistoryList
    }

    ListModel {
        id: menuItems

        ListElement {
            name: qsTr("System Info")
            view: "HomeView"
            iconSource:  "thermostat.svg"
        }
        ListElement {
            name: qsTr("Performance")
            view: "PerformanceView"
            iconSource: "stats.svg"
        }
    }

}
