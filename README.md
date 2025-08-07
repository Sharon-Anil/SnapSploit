# 📸 SnapSploit v1.0

> **A powerful camera phishing tool for educational use**  
> Created with ❤️ by [Sharon Anil](https://github.com/Sharon-Anil) — YouTube: https://www.youtube.com/@sharon_anil

## ⚠️ Disclaimer

> This tool is intended **strictly for educational and ethical hacking** purposes only.  
> Unauthorized use on real targets is **illegal**. The creator is not responsible for misuse.

---

## 🎯 Features

- 📸 Real-time camera access via browser (WebRTC-based)
- 🌐 Port forwarding via:
  - [✔] **Cloudflared** (free & fast)
  - [✔] **LocalXpose** (reliable, token-based)
- 🔐 No data leaves your machine unless tunneled
- 📁 Captured photos stored locally in `/captured`
- 📜 Fully terminal-based with colorful UI

---

## ⚙️ Requirements

- Python 3
- Flask
- `inotify-tools` (Linux)
- `cloudflared` or `loclx` (for port forwarding)

---

## 🚀 Installation

```bash
git clone https://github.com/Sharon-Anil/SnapSploit.git
cd SnapSploit
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
🛠️ Make sure cloudflared or loclx is installed and accessible in your PATH.

🧠 Optional: Install Tools
📦 Inotify Tools
bash
Copy
Edit
sudo apt install inotify-tools
🌐 Cloudflared
bash
Copy
Edit
sudo apt install cloudflared
🌐 LocalXpose
Download .deb from https://localxpose.io

Install:

bash
Copy
Edit
sudo dpkg -i loclx-linux-amd64.deb
📸 How to Use
bash
Copy
Edit
chmod +x snap.sh
./snap.sh
Select a port forwarding method (Cloudflared / LocalXpose)

Get a phishing link

Send it to the victim

When they allow camera access, photos will be auto-saved in captured/

📂 Folder Structure
bash
Copy
Edit
SnapSploit/
├── app.py               # Flask backend
├── index.html           # Webcam capture frontend
├── snap.sh              # Main bash launcher
├── captured/            # Stores victim photos
├── cloudflared.log      # Tunnel log (if used)
├── localxpose.log       # Tunnel log (if used)
└── requirements.txt     # Python dependencies
