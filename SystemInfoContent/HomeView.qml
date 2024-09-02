import QtQuick 2.15

HomeViewForm {

    Component.onCompleted: function() {

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

        // Set the values to gRPC request
        window._sysInfoReq.machineUniqueId = sysInfoProvider.machineUniqueId
        window._sysInfoReq.bootUniqueId = sysInfoProvider.bootUniqueId
        window._sysInfoReq.cpuName = sysInfoProvider.cpuName + " " + (sysInfoProvider.cpuFreq)/1000 + " GHz"
        window._sysInfoReq.currentCpuArchitecture = sysInfoProvider.currentCpuArchitecture
        window._sysInfoReq.kernelType = sysInfoProvider.kernelType
        window._sysInfoReq.kernelVersion = sysInfoProvider.kernelVersion
        window._sysInfoReq.machineHostName = sysInfoProvider.machineHostName
        window._sysInfoReq.prettyProductName = sysInfoProvider.prettyProductName
    }
}
