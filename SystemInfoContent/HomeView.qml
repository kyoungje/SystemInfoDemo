import QtQuick 2.15

HomeViewForm {

    Component.onCompleted: function() {
        busyIndicator.running = true

        uniqueID.topLabel = sysInfoProvider.machineUniqueId
        uniqueID.bottomLabel = sysInfoProvider.bootUniqueId
        cpuArch.topLabel  = sysInfoProvider.cpuName + "\r\n" + (sysInfoProvider.cpuFreq)/1000 + " GHz"
        cpuArch.bottomLabel = sysInfoProvider.currentCpuArchitecture
        kernelInfo.topLabel = sysInfoProvider.kernelType
        kernelInfo.bottomLabel = sysInfoProvider.kernelVersion
        hostName.topLabel = sysInfoProvider.machineHostName
        hostName.bottomLabel = ""
        productDetail.topLabel = sysInfoProvider.prettyProductName
        productDetail.bottomLabel = ""

        // sysInfoProvider.performOperation()
        sysInfoProvider.measureCPUFreq()
    }

    startOperation.onClicked:  {
        busyIndicator.running = true
        // sysInfoProvider.performOperation()
        sysInfoProvider.measureCPUFreq()
      }

    Connections {
        target: sysInfoProvider
        // function onOperationFinished(result) {
        //     roomName.text = "Operation result: " + result
        //     busyIndicator.running = false
        // }
        function onMeasureFreqFinished(result) {
            startOperation.text = "Freq: " + result
            busyIndicator.running = false
        }
      }
}
