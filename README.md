# 📈 Qt gRPC and System Information Management Demo

This demo project showcases a real-time communication system (i.e, *Remote management scenario for IoT devices*) between a Qt client and a Gradio server, using **Qt gRPC module** for efficient data transfer. 

It simulates an IoT remote management scenario, where a UI client gathers system information and performance metrics and sends them to a server for visualization and analysis.


## 🔹Project Overview

This project demonstrates the following key aspects:

* **Qt UI development:** The [Qt](https://www.qt.io/) client provides a user interface for retrieving system information and displaying measured performance data.
* **Real-time data transfer:** The Qt client sends system information and continuously performance data to the server.
* **gRPC communication:**  [gRPC](https://grpc.io/) is used for efficient and reliable communication between the two different Qt client and the Gradio server, that's are implemented QML and Python respectively.
* **Web server application:** The [Gradio](https://www.gradio.app/)-based web server acts as a central point for data visualization and analysis.

## 🔹Project Features

* **Qt Client:**
    *  Automatically gathers system information (Kernel, Architecture, CPU Info,... ) when loading the program        
    *  Measures CPU frequency every second and visualizes them immediately as a chart when the `Performance CPU Frequency Measure` switch is enabled. 
    *  When the `Server Sync` switch is enabled, sends collected data to the server via **Qt gRPC module**
        
    <img src="https://raw.githubusercontent.com/kyoungje/kyoungje/main/QtClient_SystemInfo.png" width="800" />

    <img src="https://raw.githubusercontent.com/kyoungje/kyoungje/main/QtClient_Performance.png" width="800" />


* **System Information Management Server:**
    *  Receives data from the Qt client via gRPC
    *  Displays the received system information and performance data
    *  Provides a user-friendly interface for visualizing data using [Gradio](https://www.gradio.app/)

    <img src="https://raw.githubusercontent.com/kyoungje/kyoungje/70a7f663cf03b6c9106dec50748e6ea0f76931ad/GradioServer_SystemInfo.png" width="800" />


## 🔹Getting Started

### Prerequisites

* **Qt Creator:**  A Qt development environment to build and run the Qt client.
* **CMake:**  A cross-platform build system for compiling the project.
* **gRPC:**  A high-performance, open-source RPC framework.
* **Gradio:**  A Python library for building and deploying web-based interfaces for machine learning models and data analysis.
* **Python:**  A programming language for running the Gradio server.

### Installation

1. **Install Qt Swoftware:**  Download and install latest Qt Framework and Tools from the [Qt website](https://www.qt.io/download-dev).
2. **Install Python:** 
3. **Install gRPC:**  Follow the instructions on the [gRPC documentation](https://grpc.io/docs/languages/python/quickstart/) to install gRPC for your platform.
4. **Install Gradio:** refer to the https://www.gradio.app/guides/quickstart


### Building the Project

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kyoungje/SystemInfoDemo.git
   ```
2. **Open the project in Qt Creator:**  Open the project in Qt Creator.
3. **Build the Qt client:**  Build the Qt client project in Qt Creator.
4. **Run the Qt client:**  Run the Qt client executable.
5. **Run the Gradio server:**  Open a terminal and navigate to the Gradio server directory. Run the Gradio server using the following command:
   ```bash
   python .\systeminfo_server.py
   ```

### Communication

The Qt client and Gradio server communicate using gRPC. The Qt client sends system information and performance data to the server, which then displays this information.


## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or would like to contribute to this project, please feel free to create an issue or submit a pull request.


## License

This project is licensed under the [your license](insert your license here) license.


## Acknowledgements

This project was inspired by the [link to any resources you used](insert link here).


## 🔹Notes

During the implemenation, some issues were met. To avoid these issue, please refer to the following descriptions. 

1. **magic8 example SimpleGrpcServer MinGW compile issue**

    MinGW can't build the server program due to suspected absail library issue.
    Note that the issue was reported to Qt bugreport [QTBUG-128174](https://bugreports.qt.io/browse/QTBUG-128174)

2. **QML can't use a stream reqeust**

    If using a `stream` request in a rpc service as below in the [systeminfo_service.proto](https://github.com/kyoungje/SystemInfoDemo/blob/80ff35cb8133776c82b8770cbb48607b1481831f/proto/systeminfo_service.proto), a QML form can't use the service. 

    It seems the issue is related to missing of `Q_INVOKABLE` function is not generated unlike the non-stream request as code below. 
    
    Thus, currently `stream` has been removed in the proto file.

   ```cpp
   rpc sendPerfData(stream SystemPerfDataRequest) returns (SystemPerfDataResponse) {}  
   ```
   ```cpp
   Q_INVOKABLE void sendPerfData(const qtgrpc::systeminfocustom::SystemPerfDataRequest &arg, const QObject *context, const std::function<void(std::shared_ptr<QGrpcCallReply>)> &callback, const QGrpcCallOptions &options = {}); 
   ```

## 🔹References

The following documentation and examples are beneficial to understand the concept and APIs of Qt, and Gradio, and implement applications in this project.

1. [Qt GRPC Documenation](https://doc.qt.io/qt-6/qtgrpc-index.html):
2. [Qt Magic 8 Ball Example](https://doc.qt.io/qt-6/qtgrpc-magic8ball-example.html)
3. [Qt Thermostat Example](https://doc.qt.io/qt-6/qtdoc-demos-thermostat-example.html) 
4. [Gradio Documenation](https://www.gradio.app/docs) 
