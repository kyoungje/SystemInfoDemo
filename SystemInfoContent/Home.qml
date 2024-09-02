import QtQuick 2.15

HomeForm {
    startSync.onCheckedChanged: {
        var perfStats = perfHistoryList.get(0)
        perfStats.sync = startSync.checked

        if (startSync.checked) {
            window.sendSysInfoToServer()
        }
    }
}
