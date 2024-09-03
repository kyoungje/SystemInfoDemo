import gradio as gr
import pandas as pd
import numpy as np
import random
import threading

import grpc_server

# Create a child thread for the gRPC server
gRPC_thread = threading.Thread(target=grpc_server.serve)
gRPC_thread.daemon = True
gRPC_thread.start()

DataStroage = grpc_server.SimpleDataStroage()
SysInfoDict = DataStroage.getSysInfo()

def update_timeStampLabel():
    oldTimeStamp = str(timeStampLabel.value["label"])
    newTimeStamp = str(SysInfoDict["timeStamp"])

    if oldTimeStamp != newTimeStamp:
        gr.Info(f"ℹ️ NEW Synchronization\r\nPrevious: {oldTimeStamp}\r\nNow: {newTimeStamp}")
        timeStampLabel.value["label"] = newTimeStamp

    return newTimeStamp


machineUniqueIdLabel = gr.Label(SysInfoDict["machineUniqueId"], label="Unique IDs", color="#7F86FA")
cpuNameLabel = gr.Label(SysInfoDict["cpuName"], label="CPU Info", color="#7F86FA")
kernelTypeLabel = gr.Label(SysInfoDict["kernelType"], label="Kernel Info", color="#7F86FA")
machineHostNameLabel = gr.Label(SysInfoDict["machineHostName"], label="Machine Name", color="#7F86FA")
prettyProductNameLabel = gr.Label(SysInfoDict["prettyProductName"], label="Product Details", color="#7F86FA")
timeStampLabel = gr.Label(SysInfoDict["timeStamp"], label="Time Stamp", color="#7F86FA")

with gr.Blocks() as demo:
    gr.Markdown(
    """
    # 🚀 System Information Management Demo
    ## This server program is designed to display system information sent from a **Qt client** using the gRPC communication.

    ### ⚙️ When `Server Sync` is enabled in the client program,
    ### Below the chart, the client's system information such as **Architecture, Kernel**, and others are displayed.
    ### ⚙️ When `CPU Performance Measure` is enabled in the client program,
    ### The **CPU Frequency** data measured by the client is visualized as a line chart in real-time. (*Note that the latest one is shown at the right*)

    ## 📈 Client Performance Chart
      
    """)
     
    timer = gr.Timer(1)
    gr.LinePlot(DataStroage.getPerfData, title="CPU Frequency (MHz)", x="Time", y="Frequency", every=timer, y_lim=[1000, 2500])
    
    gr.Markdown(
    """
      
    ## 💻 Client System Information
      
    """)

    with gr.Row():
        machineUniqueIdLabel.render()
        cpuNameLabel.render()
        kernelTypeLabel.render()

    with gr.Row():
        machineHostNameLabel.render()
        prettyProductNameLabel.render()
        timeStampLabel.render()

        demo.load(fn=(lambda : SysInfoDict["machineUniqueId"]), inputs=None, outputs=machineUniqueIdLabel, every=5)
        demo.load(fn=(lambda : SysInfoDict["cpuName"]), inputs=None, outputs=cpuNameLabel, every=5)
        demo.load(fn=(lambda : SysInfoDict["kernelType"]), inputs=None, outputs=kernelTypeLabel, every=5)
        demo.load(fn=(lambda : SysInfoDict["machineHostName"]), inputs=None, outputs=machineHostNameLabel, every=5)
        demo.load(fn=(lambda : SysInfoDict["prettyProductName"]), inputs=None, outputs=prettyProductNameLabel, every=5)
        demo.load(fn=update_timeStampLabel, inputs=None, outputs=timeStampLabel, every=5)


if __name__ == "__main__":
    try:
        demo.queue().launch()
    except KeyboardInterrupt:
        print("Parent thread received keyboard interrupt...")
