import QtQuick 2.15

HomeForm {
    startSync.onCheckedChanged: {
        var perfStats = perfHistoryList.get(0)
        perfStats.sync = startSync.checked

        // if "Server Sync" is enabled, send system information data to the server
        if (startSync.checked) {
            window.sendSysInfoToServer()
        }
    }
}
