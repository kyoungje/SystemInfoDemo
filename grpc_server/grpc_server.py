from concurrent import futures
import logging
import pandas as pd
import numpy as np
from collections import deque

import grpc
import systeminfo_service_pb2
import systeminfo_service_pb2_grpc

# Global system information dict
system_info = {
  "timeStamp": 0,
  "machineUniqueId": "No Client",
  "cpuName": "No Client",
  "currentCpuArchitecture": "No Client",
  "kernelType": "No Client",
  "kernelVersion": "No Client",
  "machineHostName": "No Client",
  "prettyProductName": "No Client",
}

# Define the storage to save data from gRPC services
class SimpleDataStroage:
    _instance = None  # class variable
    sysInfo = None

    perfData = None
    timeData = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(SimpleDataStroage, cls).__new__(cls, *args, **kwargs)
            cls.perfData = deque(maxlen=60)
            cls.perfData.extend(np.arange(60))
            cls.timeData = np.arange(60)

        return cls._instance

    def setSysInfo(self, value):
        self.sysInfo = value

    def getSysInfo(self):
        return self.sysInfo

    def insertPerfData(self, value):
        self.perfData.append(value)

    def getPerfData(self, random=0):
        if not random:
            return pd.DataFrame({
                'Frequency': np.array(self.perfData),
                'Time': self.timeData
            })
        else:
            return pd.DataFrame({
                'Frequency': np.random.randint(1000, 5000, 60),
                'Time': np.arange(60)
            })


# Instantiate a single data store and set default values
DataStroage = SimpleDataStroage()
DataStroage.setSysInfo(system_info)

# gRPC handling class
class SystemInfoService(systeminfo_service_pb2_grpc.SystemInfoServicer):
    def sendSystemInfo(self, request, context):
        sendtimeStamp = request.timeStamp.seconds + (request.timeStamp.nanos/10**9)
        SystemInfoLog = f"sendSystemInfo: {sendtimeStamp}, {request.machineUniqueId}, {request.bootUniqueId}, \
            {request.cpuName}, {request.currentCpuArchitecture}, {request.kernelType}, {request.kernelVersion}, \
            {request.machineHostName}, {request.prettyProductName}"
        print(SystemInfoLog)

        SysInfoDict = DataStroage.getSysInfo()
        SysInfoDict["timeStamp"] = sendtimeStamp
        SysInfoDict["machineUniqueId"] = request.machineUniqueId
        SysInfoDict["cpuName"]  =request.cpuName
        SysInfoDict["kernelType"] = request.kernelType
        SysInfoDict["kernelVersion"] = request.kernelVersion
        SysInfoDict["machineHostName"]  = request.machineHostName
        SysInfoDict["prettyProductName"] = request.prettyProductName

        return systeminfo_service_pb2.SystemInfoResponse(result=0)

    def sendPerfData(self, request, context):
        sendtimeStamp = request.timeStamp.seconds + (request.timeStamp.nanos/10**9)
        SystemInfoLog = f"sendPerfData: {sendtimeStamp}, {request.frequency}"
        print(SystemInfoLog)

        DataStroage.insertPerfData(request.frequency)

        return systeminfo_service_pb2.SystemPerfDataResponse(result=0)


def serve():
    logging.basicConfig()
    port = "50055"

    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    systeminfo_service_pb2_grpc.add_SystemInfoServicer_to_server(SystemInfoService(), server)
    server.add_insecure_port("[::]:" + port)

    server.start()
    print("Server started, listening on " + port)

    server.wait_for_termination()

