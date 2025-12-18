#!/bin/bash
# Kali Linux Login Alert via NTFY
# Fires ONCE per user login session

# -------------------- SESSION LOCK --------------------
LOCKFILE="/run/user/$(id -u)/login_alert_sent"

# Only send once per session
[ -f "$LOCKFILE" ] && exit 0
mkdir -p "$(dirname "$LOCKFILE")"
touch "$LOCKFILE"
# ------------------------------------------------------

# -------------------- DATA ---------------------------
USER="$PAM_USER"
HOST="$(hostname)"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
IP="$(curl -m 3 -s https://ifconfig.me || echo "N/A")"

TITLE="🔐 Kali Linux Login Alert"

MESSAGE="User: $USER
System: $HOST
Time: $DATE
IP: $IP"
# ------------------------------------------------------

# -------------------- SEND ALERT ---------------------
curl -s -m 5 -d "$MESSAGE" \
     -H "Title: $TITLE" \
     -H "Priority: high" \
     https://ntfy.sh/kali-login >/dev/null 2>&1 || true
# ------------------------------------------------------

exit 0
