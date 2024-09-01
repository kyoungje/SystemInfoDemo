import QtQuick 2.15

PerformanceViewForm {
    startMeasure.onClicked: {
        sysInfoProvider.startMeasureCPUFreq()
    }

    stopMeasure.onClicked: {
        sysInfoProvider.stopMeasureCPUFreq()
    }
}
