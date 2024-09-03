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
SysInfoDict = DataStroage.get()

def get_data():
    return pd.DataFrame({
        'Frequency': np.random.randint(1000, 5000, 60),
        'Time': np.arange(60)
    })


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
    # 🚀 System Information Server Demo
    ## This server is designed to work with a Qt client using gRPC communication. When `Server Sync` is enabled in the client program,
    - The **CPU frequency** data measured by the client is displayed in a line plot in real time.  
    - Below the chart, the client's system information such as **Architecture, Kernel**, etc are listed as shown.
      
    ## 📈 Client Performance Chart
      
    """)
     
    timer = gr.Timer(1)
    gr.LinePlot(get_data, title="CPU Frequency (MHz)", x="Time", y="Frequency", color_map={"Frequency": "#2FA8C3"}, y_aggregate=['min', 'max'], every=timer, )
    
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
