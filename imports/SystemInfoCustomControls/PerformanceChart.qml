// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtCharts
import SystemInfoCustom

Pane {
    id: root

    // property alias spline: spline

    width: 900
    height: 580

    padding: 0
    property var historyModel
    property var perfStats: historyModel.get(0)
    property int maxHistory: perfStats.maxCount

    property var tempValues: {
        var temp = Array(maxHistory);
        var historyNum = maxHistory;
        var curHistoryIndex = perfStats.curIndex;

        while (--historyNum >= 0){
            temp[historyNum] = perfStats.freqStats.get(curHistoryIndex).freq;

            if (--curHistoryIndex < 0)
                curHistoryIndex = maxHistory - 1;
        }
        return temp;
    }

    property real maxValue
    property real minValue
    property real curValue

    background: Rectangle {
        radius: 12
        color: Constants.accentColor
    }

    ValuesAxis {
        id: splineChartAxisY

        min: 1000
        max: 4000
        tickAnchor: 500
        tickInterval: 500
        tickType: ValuesAxis.TicksDynamic
        labelsColor: internal.splineChartColor
        labelsFont.family: "Titillium Web"
        lineVisible: false
        gridLineColor: internal.splineGridColor
        labelsFont.pixelSize: internal.axisFontSize
    }

    ValuesAxis {
        id: splineChartAxisX
        tickAnchor: 10
        tickInterval: 10
        visible: false
        min: 0
        max: root.maxHistory
    }

    ChartView {
        id: chart

        title: "STATSTICS Minimum/Current/Maximum (MHz): " + minValue + " / " + curValue + " / " + maxValue
        titleColor: "#FFFF00"
        titleFont: Constants.smallTitleFont
        anchors.fill: parent
        antialiasing: true

        margins.left: 0
        margins.right: 0
        margins.top: 0
        margins.bottom: 0

        legend.alignment: Qt.AlignTop
        legend.markerShape: Legend.MarkerShapeCircle
        legend.font.family: "Titillium Web"
        legend.font.weight: 400
        legend.font.pixelSize: internal.fontSize
        legend.labelColor: Constants.primaryTextColor

        dropShadowEnabled: internal.dropShadowEnabled
        backgroundColor: Constants.accentColor

        SplineSeries {
            id: spline

            name: "CPU Frequency [MHz]"
            color: internal.splineChartColor
            width: internal.lineWidth

            axisX: splineChartAxisX
            axisYRight: splineChartAxisY

            Component.onCompleted: function () {
                for (var i = 0; i < tempValues.length; i++) {
                    spline.append(i, tempValues[i]);
                }
            }

            Connections {
                target: sysInfoProvider

                function onMeasureCPUFreqEvent(result) {
                    curValue = (result/1000000).toFixed(1);

                    tempValues.shift();
                    tempValues.push(curValue);

                    maxValue = Math.max(...tempValues).toFixed(1);
                    minValue = Math.min(...tempValues.filter(value => value !== 0)).toFixed(1);

                    for (var i = 0; i < tempValues.length; i++) {
                        spline.replace(i, i, tempValues[i]);
                    }
                }
            }
        }
    }

    QtObject {
        id: internal

        property int fontSize: 14
        property int axisFontSize: 14
        property int lineWidth: 3
        property bool dropShadowEnabled: true
        readonly property color splineChartColor: "#2FA8C3"
        readonly property color splineGridColor: "#707070"
    }

    // Component.onCompleted: function () {
    //     maxValue = Math.max(...tempValues).toFixed(1);
    //     minValue = Math.min(...tempValues).toFixed(1);
    //     avgValue = (tempValues.reduce((a, b) => a + b, 0) / tempValues.length).toFixed(1);
    // }
}
