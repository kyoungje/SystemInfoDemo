pragma Singleton
import QtQuick 6.7

QtObject {
    readonly property int width: 640
    readonly property int height: 480

    property string currentView: "HomeView"

    property bool isBigDesktopLayout: true
    property bool isSmallDesktopLayout: false
    property bool isMobileLayout: false
    property bool isSmallLayout: false

    property string relativeFontDirectory: "fonts"

    /* Edit this comment to add your custom font */
    readonly property font font: Qt.font({
                                             family: Qt.application.font.family,
                                             pixelSize: Qt.application.font.pixelSize
                                         })
    readonly property font largeFont: Qt.font({
                                                  family: Qt.application.font.family,
                                                  pixelSize: Qt.application.font.pixelSize * 1.6
                                              })

    readonly property font smallTitleFont: Qt.font({
            "family": "Inter",
            "pixelSize": 14,
            "weight": 700
        })

    readonly property font mobileTitleFont: Qt.font({
            "family": "Titillium Web",
            "pixelSize": 24,
            "weight": 600
        })

    readonly property font desktopTitleFont: Qt.font({
            "family": "Titillium Web",
            "pixelSize": 48,
            "weight": 600
        })

    readonly property font desktopSubtitleFont: Qt.font({
            "family": "Titillium Web",
            "pixelSize": 24,
            "weight": 600
        })

    readonly property color backgroundColor: "#000000"
    readonly property color accentColor: "#002125"
    readonly property color primaryTextColor: "#FFFFFF"
    readonly property color accentTextColor: "#D9D9D9"
    readonly property color iconColor: "#D9D9D9"

}
