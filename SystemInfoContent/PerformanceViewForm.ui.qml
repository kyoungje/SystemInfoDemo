

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import SystemInfoCustom

Pane {
    id: root

    leftPadding: 20
    rightPadding: 20
    bottomPadding: 15

    property int currentRoomIndex: 0
    // required property var roomsList

    background: Rectangle {
        color: Constants.backgroundColor
    }

    Column {
        id: title

        width: parent.width

        Label {
            id: header

            text: qsTr("Statistics")
            font: Constants.desktopTitleFont
            color: Constants.primaryTextColor
            elide: Text.ElideRight
        }
    }

    QtObject {
        id: internal

        readonly property int contentHeight: root.height - title.height
                                             - root.topPadding - root.bottomPadding
        readonly property int contentWidth: root.width - root.rightPadding - root.leftPadding
        readonly property bool isOneColumn: contentWidth < 900
    }
}
