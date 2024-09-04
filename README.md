# 📈 Qt gRPC and System Information Management Demo

This demo project showcases a real-time communication system (ex. *Remote management scenario for IoT devices*) between a Qt client and a web UI server, using **Qt gRPC module** for efficient data transfer. 

It simulates the IoT remote management scenario, where a UI client gathers system information and performance metrics and sends them to a server for visualization and analysis.

<img src="https://raw.githubusercontent.com/kyoungje/kyoungje/main/QtClient_SystemInfo.png" width="800" />


## 🔹Project Overview

This project demonstrates the following key aspects:

* **Qt UI development:** The [Qt](https://www.qt.io/) client provides a user interface for retrieving system information and displaying measured performance data.
* **Real-time data transfer:** The Qt client sends system information and real-time performance data to the server.
* **Communication using gRPC Qt module:**  [gRPC](https://grpc.io/) is used for efficient and reliable communication between the two different Qt client and the Gradio server, that's are implemented in QML and Python respectively.
* **Web UI server application:** The [Gradio](https://www.gradio.app/)-based web server acts as a central point for data visualization and analysis.

## 🔹Project Features

### Qt Client

*  Automatically gathers system information (Kernel, Architecture, CPU,... ) when loading the program        
*  Measures CPU frequency every second and visualizes them immediately as a chart when the `Performance CPU Frequency Measure` switch is enabled. 
*  When the `Server Sync` switch is enabled, sends collected data to the server via **Qt gRPC module**
        

<img src="https://raw.githubusercontent.com/kyoungje/kyoungje/main/QtClient_Performance.png" width="800" />

### System Information Management Server
*  Receives data from the Qt client via gRPC
*  Displays the received system information and performance data immediately
*  Provides a user-friendly interface for visualizing data using [Gradio](https://www.gradio.app/)

<img src="https://raw.githubusercontent.com/kyoungje/kyoungje/70a7f663cf03b6c9106dec50748e6ea0f76931ad/GradioServer_SystemInfo.png" width="800" />


## 🔹Getting Started

### Prerequisites

* **Qt Creator:**  A Qt development environment to build and run the Qt client.
* **CMake:**  A cross-platform build system for compiling the project.
* **gRPC:**  A high-performance, open-source RPC framework.
* **Python:**  A programming language for running the Gradio server.
* **Gradio:**  A Python library for building and deploying web-based interfaces for machine learning models and data analysis.


### Installation

1. **Install Qt Swoftware:** Download and install latest Qt Framework and Tools from the [Qt website](https://www.qt.io/download-dev).
2. **Install Python:** Download and install latest Pytohon at [the website](https://www.python.org/downloads/).
3. **Install gRPC:**  Follow the instructions on the [gRPC documentation](https://grpc.io/docs/languages/python/quickstart/) to install gRPC for your platform.
4. **Install Gradio:** Refer to the [documentaion](https://www.gradio.app/guides/quickstart). 


### Building the Project

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kyoungje/SystemInfoDemo.git
   ```
2. **Open the project in Qt Creator:**  Open the project in Qt Creator.
3. **Build the Qt client:**  Build the Qt client project in Qt Creator.
4. **Run the Qt client:**  Run the Qt client executable.
5. **Run the server:**  Open a terminal and navigate to the project directory. There is a directory named `grpc_server` where server scripts are located.  Run the server program using the following command:
   ```bash
   cd grpc_server
   python .\systeminfo_server.py
   ```

## 🔹Software Design

The Qt client and Gradio server communicate using gRPC. The Qt client sends system information and performance data to the server, which then displays this information.

<img src="https://raw.githubusercontent.com/kyoungje/kyoungje/main/SysinfoDemo_architecture.png" width="800" />

For the Qt client, several QML files are used to create a Qt UI application as below. (This UI code mainly refers to the [Thermostat](https://doc.qt.io/qt-6/qtdoc-demos-thermostat-example.html) example.)
- `App.qml`, `Home.qml`, `SideBar.qml`, `HomveView.qml`, `PerformanceView.qml`

`SysInfoProvider` is implemented in C++ and has capabilities to retrieve system information using [QSysInfo](https://doc.qt.io/qt-6/qsysinfo.html) class and Windows WMI commands. Also, it can measure the CPU frequency with simple and less correct algorithms

`systeminfo_server` is a main server that provides UI to users. When starting the server, the `gRPC server` is created as a separate thread.

The `gRPC server` handles the client gRPC request and saves the information to a simple data storage and later `systeminfo_server` uses the data for displaying information on web UI.

## 🔹Notes

During the implementation of the project, some issues were met. 

Note that the program is developed with **Qt version 6.7.2**, **Gradio version 4.42.0**, and **gRPC 1.66.1**, so the issue could disappear in different configurations.

Here is the list of issues. Please read the following descriptions that explain how to avoid the issues in this project.

1. **gRPC server in Qt gRPC examples cannot build with MinGW compiler**

    Unlike MSVC, MinGW can't build the server program provided by [the examples](https://github.com/abseil/abseil-cpp/issues/1657) due to a suspected [absail library issue](https://github.com/abseil/abseil-cpp/issues/1657).
    Note that the issue was reported to Qt bug report [QTBUG-128174](https://bugreports.qt.io/browse/QTBUG-128174) and a warning message will be included in a subsequent release.

2. **QML doesn't generate invockable gRPC service when using a stream reqeust**

    If using a `stream` request in an RPC service as below in the [systeminfo_service.proto](https://github.com/kyoungje/SystemInfoDemo/blob/80ff35cb8133776c82b8770cbb48607b1481831f/proto/systeminfo_service.proto), a QML form can't use the service. 

    The issue is likely caused by the generated header file that doesn't have the necessary `Q_INVOKABLE` function, while the non-stream request makes the function generated correctly as the code below. 
    
    Thus, currently for this project the `stream` has been removed from the proto file.

   ```cpp
   rpc sendPerfData(stream SystemPerfDataRequest) returns (SystemPerfDataResponse) {}  
   ```
   ```cpp
   Q_INVOKABLE void sendPerfData(const qtgrpc::systeminfocustom::SystemPerfDataRequest &arg, const QObject *context, const std::function<void(std::shared_ptr<QGrpcCallReply>)> &callback, const QGrpcCallOptions &options = {}); 
   ```

3. **Gradio UI update with external data change**
    
    It seems, by design, that Gradio doesn't allow updates to UI components from external threads. Those UI components should be updated in other Gradio component events in general.

    To mitigate this issue, the UI components like `label` in this project are updated using the `every` argument as a polling mechanism.
    
    ```python
    demo.load(fn=(lambda : SysInfoDict["machineUniqueId"]), inputs=None, outputs=machineUniqueIdLabel, every=5)
    ```
    
    FYI, refer to [souce code](https://github.com/kyoungje/SystemInfoDemo/blob/30b454f429fb32d979494bf5254d09a1c23bf91b/grpc_server/systeminfo_server.py#L70) and [discussion](https://discuss.huggingface.co/t/update-textbox-content-from-other-thread/23599).

## 🔹References

The following documentation and examples are beneficial to understand the concept and APIs of Qt, and Gradio, and implement applications in this project.

1. [Qt GRPC Documenation](https://doc.qt.io/qt-6/qtgrpc-index.html):
2. [Qt Magic 8 Ball Example](https://doc.qt.io/qt-6/qtgrpc-magic8ball-example.html)
3. [Qt Thermostat Example](https://doc.qt.io/qt-6/qtdoc-demos-thermostat-example.html) 
4. [Gradio Documenation](https://www.gradio.app/docs) 
