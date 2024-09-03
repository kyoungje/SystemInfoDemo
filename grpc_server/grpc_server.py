from concurrent import futures
import logging

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
    SysInfo = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(SimpleDataStroage, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def set(self, value):
        SimpleDataStroage.SysInfo = value

    def get(self):
        return SimpleDataStroage.SysInfo


DataStroage = SimpleDataStroage()
DataStroage.set(system_info)

class SystemInfoService(systeminfo_service_pb2_grpc.SystemInfoServicer):
    def sendSystemInfo(self, request, context):
        sendtimeStamp = request.timeStamp.seconds + (request.timeStamp.nanos/10**9)
        result = f"sendSystemInfo: {sendtimeStamp}, {request.machineUniqueId}, {request.bootUniqueId}, \
            {request.cpuName}, {request.currentCpuArchitecture}, {request.kernelType}, {request.kernelVersion}, \
            {request.machineHostName}, {request.prettyProductName}"
        print(result)

        SysInfoDict = DataStroage.get()
        SysInfoDict["timeStamp"] = sendtimeStamp
        SysInfoDict["machineUniqueId"] = request.machineUniqueId
        SysInfoDict["cpuName"]  =request.cpuName
        SysInfoDict["kernelType"] = request.kernelType
        SysInfoDict["kernelVersion"] = request.kernelVersion
        SysInfoDict["machineHostName"]  = request.machineHostName
        SysInfoDict["prettyProductName"] = request.prettyProductName

        return systeminfo_service_pb2.SystemInfoResponse(result=0)


def serve():
    logging.basicConfig()
    port = "50055"

    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    systeminfo_service_pb2_grpc.add_SystemInfoServicer_to_server(SystemInfoService(), server)
    server.add_insecure_port("[::]:" + port)

    server.start()
    print("Server started, listening on " + port)

    server.wait_for_termination()

