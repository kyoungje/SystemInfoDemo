

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

    property alias startMeasure: startMeasure

    required property var perfHistoryList

    leftPadding: 20
    rightPadding: 20
    bottomPadding: 15

    clip: true
    padding: 0
    contentWidth: availableWidth

    property int delegateWidth: 350
    property int delegateHeight: 182
    property int performanceChartWidth: 1098
    property int performanceChartHeight: 647

    background: Rectangle {
        anchors.fill: parent
        color: Constants.backgroundColor
    }

    Column {
        id: title

        width: parent.width

        Label {
            id: header

            text: qsTr("Performance")
            font: Constants.desktopTitleFont
            color: Constants.primaryTextColor
            elide: Text.ElideRight
        }

        Label {
            text: qsTr("Measure of the current CPU's freqeuncy")
            font.pixelSize: 24
            font.weight: 600
            font.family: "Titillium Web"
            color: Constants.accentTextColor
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        CustomSwitch {
            id: startMeasure
            checked: perfHistoryList.active
            // onCheckedChanged: perfHistoryList.active = startMeasure.checked
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

        Pane {
            id: performance

            leftPadding: 53
            rightPadding: 53
            topPadding: 23
            bottomPadding: 43

            Layout.columnSpan: 3
            Layout.rowSpan: 1

            Layout.preferredHeight: root.performanceChartHeight
            Layout.preferredWidth: root.performanceChartWidth
            Layout.alignment: Qt.AlignHCenter

            background: Rectangle {
                radius: 12
                color: Constants.accentColor
            }

            PerformanceChart {
                id: performanceChart

                historyModel: root.perfHistoryList
                anchors.fill: parent
            }
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
