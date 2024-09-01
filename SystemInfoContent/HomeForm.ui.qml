

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

Page {
    id: root

    property alias perfHistoryList: perfHistoryList

    background: Rectangle {
        color: Constants.accentColor
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
