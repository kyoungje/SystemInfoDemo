import QtQuick 2.15

PerformanceViewForm {
    startMeasure.onCheckedChanged: {
        perfHistoryList.active = startMeasure.checked

        if (startMeasure.checked)
            sysInfoProvider.startMeasureCPUFreq()
        else
            sysInfoProvider.stopMeasureCPUFreq()
    }
}
