import gradio as gr
import pandas as pd
import numpy as np
import random

def get_data():
    return pd.DataFrame({
        'Frequency': np.random.randint(1000, 5000, 60),
        'Time': np.arange(60)
    })

hello_world = gr.Interface(lambda name: "Hello " + name, "text", "text")
bye_world = gr.Interface(lambda name: "Bye " + name, "text", "text")

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
        gr.Label("a", label="Unique IDs")
        gr.Label("b", label="CPU Info")
        gr.Label("c", label="Kernel Info")
    with gr.Row():
        gr.Label("d", label="Machine Name")
        gr.Label("e", label="Product Details")
        gr.Label("f", label="Performance Data Info")

if __name__ == "__main__":
    demo.launch()
