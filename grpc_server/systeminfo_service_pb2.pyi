from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Mapping as _Mapping, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class TimeStamp(_message.Message):
    __slots__ = ("seconds", "nanos")
    SECONDS_FIELD_NUMBER: _ClassVar[int]
    NANOS_FIELD_NUMBER: _ClassVar[int]
    seconds: int
    nanos: int
    def __init__(self, seconds: _Optional[int] = ..., nanos: _Optional[int] = ...) -> None: ...

class SystemInfoRequest(_message.Message):
    __slots__ = ("timeStamp", "machineUniqueId", "bootUniqueId", "cpuName", "currentCpuArchitecture", "kernelType", "kernelVersion", "machineHostName", "prettyProductName")
    TIMESTAMP_FIELD_NUMBER: _ClassVar[int]
    MACHINEUNIQUEID_FIELD_NUMBER: _ClassVar[int]
    BOOTUNIQUEID_FIELD_NUMBER: _ClassVar[int]
    CPUNAME_FIELD_NUMBER: _ClassVar[int]
    CURRENTCPUARCHITECTURE_FIELD_NUMBER: _ClassVar[int]
    KERNELTYPE_FIELD_NUMBER: _ClassVar[int]
    KERNELVERSION_FIELD_NUMBER: _ClassVar[int]
    MACHINEHOSTNAME_FIELD_NUMBER: _ClassVar[int]
    PRETTYPRODUCTNAME_FIELD_NUMBER: _ClassVar[int]
    timeStamp: TimeStamp
    machineUniqueId: str
    bootUniqueId: str
    cpuName: str
    currentCpuArchitecture: str
    kernelType: str
    kernelVersion: str
    machineHostName: str
    prettyProductName: str
    def __init__(self, timeStamp: _Optional[_Union[TimeStamp, _Mapping]] = ..., machineUniqueId: _Optional[str] = ..., bootUniqueId: _Optional[str] = ..., cpuName: _Optional[str] = ..., currentCpuArchitecture: _Optional[str] = ..., kernelType: _Optional[str] = ..., kernelVersion: _Optional[str] = ..., machineHostName: _Optional[str] = ..., prettyProductName: _Optional[str] = ...) -> None: ...

class SystemInfoResponse(_message.Message):
    __slots__ = ("result",)
    RESULT_FIELD_NUMBER: _ClassVar[int]
    result: int
    def __init__(self, result: _Optional[int] = ...) -> None: ...

class SystemPerfDataRequest(_message.Message):
    __slots__ = ("timeStamp", "frequency")
    TIMESTAMP_FIELD_NUMBER: _ClassVar[int]
    FREQUENCY_FIELD_NUMBER: _ClassVar[int]
    timeStamp: TimeStamp
    frequency: int
    def __init__(self, timeStamp: _Optional[_Union[TimeStamp, _Mapping]] = ..., frequency: _Optional[int] = ...) -> None: ...

class SystemPerfDataResponse(_message.Message):
    __slots__ = ("result",)
    RESULT_FIELD_NUMBER: _ClassVar[int]
    result: int
    def __init__(self, result: _Optional[int] = ...) -> None: ...
