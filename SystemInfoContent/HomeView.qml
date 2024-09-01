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
    }
}
