from concurrent import futures
import logging

import grpc
import systeminfo_service_pb2
import systeminfo_service_pb2_grpc


class SystemInfoService(systeminfo_service_pb2_grpc.SystemInfoServicer):
    def sendSystemInfo(self, request, context):
        send_time = request.timeStamp.seconds + (request.timeStamp.nanos/10**9)
        result = f"sendSystemInfo: {send_time}, {request.machineUniqueId}, {request.bootUniqueId}, \
            {request.cpuName}, {request.currentCpuArchitecture}, {request.kernelType}, {request.kernelVersion}, \
            {request.machineHostName}, {request.prettyProductName}"
        print(result)

        return systeminfo_service_pb2.SystemInfoResponse(result=0)


def serve():
    port = "50055"
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    systeminfo_service_pb2_grpc.add_SystemInfoServicer_to_server(SystemInfoService(), server)
    server.add_insecure_port("[::]:" + port)
    server.start()
    print("Server started, listening on " + port)
    server.wait_for_termination()


if __name__ == "__main__":
    logging.basicConfig()
    serve()
