

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

Pane {
    id: root

    property alias startOperation: startOperation
    property alias uniqueID: uniqueID
    property alias cpuArch: cpuArch
    property alias kernelInfo: kernelInfo
    property alias hostName: hostName
    property alias productDetail: productDetail

    property alias busyIndicator: busyIndicator

    topPadding: 4
    leftPadding: 27
    rightPadding: 27
    bottomPadding: 13
    property int delegateWidth: 350
    property int delegateHeight: 182

    clip: true
    padding: 0
    contentWidth: availableWidth

    // required property var roomsList

    background: Rectangle {
        anchors.fill: parent
        color: Constants.backgroundColor
    }

    Column {
        id: title

        width: internal.contentWidth

        Label {
            id: heading

            text: qsTr("System Information")
            font: Constants.desktopTitleFont
            color: Constants.primaryTextColor
            elide: Text.ElideRight
        }

        Label {
            text: qsTr("The summary of your system's resource")
            font.pixelSize: 24
            font.weight: 600
            font.family: "Titillium Web"
            color: Constants.accentTextColor
            elide: Text.ElideRight
            Layout.fillWidth: true
        }
    }

    GridLayout {
        id: grid

        anchors.top: title.bottom
        anchors.topMargin: 12
        anchors.leftMargin: 28
        anchors.bottomMargin: 12
        anchors.rightMargin: 28

        width: root.contentWidth
        height: root.contentHeight

        columns: 3
        rows: 3
        columnSpacing: 10
        rowSpacing: 10

        SystemElementControl {
            id: uniqueID

            title: "Unique IDs"
            topLabel: "Boot UniqueId: "
            bottomLabel: "Machine UniqueId: "

            Layout.preferredHeight: root.delegateHeight
            Layout.preferredWidth: root.delegateWidth
            Layout.alignment: Qt.AlignHCenter
        }

        SystemElementControl {
            id: cpuArch

            title: "CPU"
            topLabel: "Current CPU Architecture"
            bottomLabel: "Architecture: "

            Layout.preferredHeight: root.delegateHeight
            Layout.preferredWidth: root.delegateWidth
            Layout.alignment: Qt.AlignHCenter
        }

        SystemElementControl {
            id: kernelInfo

            title: "Kernel"
            topLabel: "Kernel Type: "
            bottomLabel: "Kernel Version: "

            Layout.preferredHeight: root.delegateHeight
            Layout.preferredWidth: root.delegateWidth
            Layout.alignment: Qt.AlignHCenter
        }

        SystemElementControl {
            id: hostName

            title: "Machines Name"
            topLabel: "Name: "
            bottomLabel: "Prertty Name: "

            Layout.preferredHeight: root.delegateHeight
            Layout.preferredWidth: root.delegateWidth
            Layout.alignment: Qt.AlignHCenter
        }

        SystemElementControl {
            id: productDetail

            title: "Product Details"
            topLabel: "Product Type: "
            bottomLabel: "Product Version: "

            Layout.preferredHeight: root.delegateHeight
            Layout.preferredWidth: root.delegateWidth
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            id: startOperation
            text: qsTr("Start operation")
            palette.buttonText: Constants.primaryTextColor
        }

        BusyIndicator {
            id: busyIndicator
            running: false
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40
                color: "#e0e0e0"
                visible: parent.running
            }
        }
    }

    // Pane {
    //     id: systemInfoItem
    //     anchors.top: grid.bottom
    //     anchors.topMargin: 12
    //     anchors.leftMargin: 28

    //     width: systemInfoInternal.contentWidth
    //     height: systemInfoInternal.contentHeight

    //     background: Rectangle {
    //         color: Constants.accentColor
    //         radius: 12
    //     }

    //     Row {
    //         anchors.left: parent.left
    //         anchors.top: parent.top
    //         anchors.leftMargin: systemInfoInternal.leftMargin
    //         anchors.topMargin: systemInfoInternal.topMargin
    //         // spacing: systemInfoInternal.headerSpacing

    //         Label {
    //             id: roomName
    //             text: qsTr("Living room")
    //             // font.pixelSize: systemInfoInternal.headerSize
    //             font.weight: 600
    //             font.family: "Titillium Web"
    //             color: Constants.primaryTextColor
    //         }

    //         Button {
    //             id: startOperation
    //             text: qsTr("Start operation")
    //             palette.buttonText: Constants.primaryTextColor
    //         }
    //     }

    //     BusyIndicator {
    //         id: busyIndicator
    //         running: false
    //         background: Rectangle {
    //             implicitWidth: 100
    //             implicitHeight: 40
    //             color: "#e0e0e0"
    //             visible: parent.running
    //         }
    //     }

    //     // Popup {
    //     //     anchors.centerIn: Overlay.overlay
    //     //     closePolicy: Popup.NoAutoClose
    //     //     modal: true

    //     //     BusyIndicator {
    //     //         running: true
    //     //     }
    //     // }

    //     QtObject {
    //         id: systemInfoInternal

    //         readonly property int contentHeight: 900
    //         readonly property int contentWidth: root.width - root.rightPadding - root.leftPadding

    //         readonly property int leftMargin: 20
    //         readonly property int topMargin: 16
    //     }
    // }

    QtObject {
        id: internal

        readonly property int contentHeight: root.height - title.height
                                             - root.topPadding - root.bottomPadding
        readonly property int contentWidth: root.width - root.rightPadding - root.leftPadding
        property int delegatePreferredHeight: 276
        property int delegatePreferredWidth: 530
    }
}
