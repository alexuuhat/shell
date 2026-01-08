import requests
import socket
import datetime

BOT_TOKEN = "<TOKEN>"
CHAT_ID = "<CHAT ID HERE>"

hostname = socket.gethostname()
time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# Get public IP
try:
    public_ip = requests.get("https://api.ipify.org", timeout=5).text
except:
    public_ip = "N/A"

msg = f"🟢 Linux root Login Detected\nHost: {hostname}\nPublic IP: {public_ip}\nTime: {time_now}"

url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
requests.post(url, data={
    "chat_id": CHAT_ID,
    "text": msg
})
