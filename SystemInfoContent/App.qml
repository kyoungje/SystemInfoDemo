// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick 6.7
import QtGrpc
import SystemInfoCustom
import qtgrpc.systeminfocustom

Window {
    id: window

    width: Constants.width
    height: Constants.height

    minimumHeight: 272

    visible: true
    title: "System Information Client Demo"

    property systemInfoRequest  _sysInfoReq
    property systemInfoResponse _sysInfoResp
    property var setSysInfoResponse: function(value) { window._sysInfoResp = value }

    property systemPerfDataRequest  _perfDataReq
    property systemPerfDataResponse _perfDataResp
    property var setPerfDataResponse: function(value) { window._perfDataResp = value }

    property var textError
    property var errorCallback: function() { console.log("Error can be handled also here") }

    Home {
        id: mainScreen
        anchors.fill: parent

        Component.onCompleted: function() {
            var perfStats = perfHistoryList.get(0);

            for (let i = 0; i < perfStats.maxCount; ++i) {
                perfStats.freqStats.append({"freq": 0});
            }

            perfStats.curIndex = perfStats.maxCount-1;
        }
    }

    Connections {
        target: grpcClient
        function onErrorOccurred() {
            window.textError = "No connection\nto\nserver"
        }
    }

    // Send system information to server using the gRPC service
    function sendSysInfoToServer()
    {
        var millis = Date.now()

        _sysInfoReq.timeStamp.seconds = (millis / 1000)
        _sysInfoReq.timeStamp.nanos = ((millis % 1000) * 1000000)
        grpcClient.sendSystemInfo(_sysInfoReq, setSysInfoResponse, errorCallback)
    }

    // Send perforance data to server using the gRPC service
    function sendPerfDataToServer(freq)
    {
        var millis = Date.now()

        _perfDataReq.timeStamp.seconds = (millis / 1000)
        _perfDataReq.timeStamp.nanos = ((millis % 1000) * 1000000)
        _perfDataReq.frequency = freq
        grpcClient.sendPerfData(_perfDataReq, setPerfDataResponse, errorCallback)
    }

    SystemInfoClient {
        id: grpcClient
        channel: grpcChannel.channel
    }

    GrpcHttp2Channel {
        id: grpcChannel
        options: GrpcChannelOptions {
            id: channelOptions
            host: "http://localhost:50055"
        }
    }
}

