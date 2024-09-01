// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtCharts
import SystemInfoCustom

Pane {
    id: root

    width: 900
    height: 580

    padding: 0
    required property var historyModel
    property int maxHistory: historyModel.maxCount

    property real maxValue
    property real minValue
    property real curValue

    function setSplineValues() {

        var tempArray = Array(maxHistory);
        var historyNum = maxHistory;
        var curHistoryIndex = historyModel.curIndex;

        var findMinValue = 0;
        var findMaxValue = 0;

        while (--historyNum >= 0) {
            tempArray[historyNum] = historyModel.freqStats.get(curHistoryIndex).freq;

            if (--curHistoryIndex < 0)
                curHistoryIndex = maxHistory - 1;

            if (findMaxValue == 0 || findMaxValue < tempArray[historyNum])
                findMaxValue = tempArray[historyNum];

            if (findMinValue == 0 || findMinValue > tempArray[historyNum])
                findMinValue = tempArray[historyNum];
        }

        minValue = findMinValue;
        maxValue = findMaxValue;

        // console.log("Modified idx:", historyModel.curIndex, "Data:", tempArray);

        return tempArray;
    }

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

        title: "[Statistics] Min: %1 / Current: %2 / Max: %3 (MHz)".arg(minValue).arg(curValue).arg(maxValue)
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
                var tempArray = setSplineValues();
                for (var i = 0; i < tempArray.length; i++) {
                    spline.append(i, tempArray[i]);
                }
            }

            Connections {
                target: sysInfoProvider

                function onMeasureCPUFreqEvent(result) {
                    curValue = Math.trunc(result/1000000);

                    var tempArray = setSplineValues();
                    for (var i = 0; i < tempArray.length; i++) {
                        spline.replace(i, i, tempArray[i]);
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
