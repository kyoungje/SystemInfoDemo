import QtQuick 2.15

PerformanceViewForm {
    startMeasure.onCheckedChanged: {
        perfHistoryList.active = startMeasure.checked

        // if "CPU Performance Measure" is checked, enable the SystemInfoProver to measure the CPU frequency
        if (startMeasure.checked)
            sysInfoProvider.startMeasureCPUFreq()
        else
            sysInfoProvider.stopMeasureCPUFreq()
    }
}
