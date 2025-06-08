import subprocess
import requests
from datetime import datetime

def run_shell(cmd):
    """Chạy lệnh shell và trả về kết quả chuỗi đã strip"""
    return subprocess.check_output(cmd, shell=True, text=True).strip()

def get_governor_status():
    """Check governor status from metrics endpoint"""
    try:
        response = requests.get("http://localhost:8080/metrics", timeout=5)
        response.raise_for_status()

        for line in response.text.split('\n'):
            if line.startswith('is_governor ') and not line.startswith('#'):
                # Extract value from line like "is_governor 1"
                parts = line.split()
                if len(parts) >= 2:
                    value = int(parts[1])
                    if value == 0:
                        return "🟡 Candidate"
                    elif value == 1:
                        return "🟢 Governor"
                    else:
                        return f"❓ Unknown ({value})"

        return "❌ Metric Not Found"
    except requests.exceptions.RequestException:
        return "❌ Metrics Unavailable"
    except Exception as e:
        return f"❌ Error: {str(e)[:20]}"
    """Format timedelta for better readability"""
    total_seconds = int(td.total_seconds())
    if total_seconds < 60:
        return f"{total_seconds}s"
    elif total_seconds < 3600:
        minutes = total_seconds // 60
        seconds = total_seconds % 60
        return f"{minutes}m {seconds}s"
    else:
        hours = total_seconds // 3600
        minutes = (total_seconds % 3600) // 60
        return f"{hours}h {minutes}m"

def get_diff_block():
    try:
        # Lấy block height từ log node local
        log_block_height = int(run_shell(
            "tail -n 1000 /var/log/redbelly/rbn_logs/rbbc_logs.log | "
            "grep 'number' | sed -E 's/.*\"number\": \"([0-9]+)\".*/\\1/' | tail -n 1"
        ))

        # Lấy block height từ RPC mainnet
        payload = {
            "method": "eth_getBlockByNumber",
            "params": ["latest", False],
            "id": 1,
            "jsonrpc": "2.0"
        }
        response = requests.post(
            "https://governors.mainnet.redbelly.network",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        latest_block_hex = response.json()["result"]["number"]
        latest_block_height = int(latest_block_hex, 16)

        # Tính độ lệch block
        difference = abs(log_block_height - latest_block_height)

        return difference

    except Exception as e:
        return -1

def get_redbelly_status_html():
    try:
        # Lấy block height từ log node local
        log_block_height = int(run_shell(
            "tail -n 1000 /var/log/redbelly/rbn_logs/rbbc_logs.log | "
            "grep 'number' | sed -E 's/.*\"number\": \"([0-9]+)\".*/\\1/' | tail -n 1"
        ))

        # Lấy block height từ RPC mainnet
        payload = {
            "method": "eth_getBlockByNumber",
            "params": ["latest", False],
            "id": 1,
            "jsonrpc": "2.0"
        }
        response = requests.post(
            "https://governors.mainnet.redbelly.network",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        latest_block_hex = response.json()["result"]["number"]
        latest_block_height = int(latest_block_hex, 16)

        # Tính độ lệch block
        difference = abs(log_block_height - latest_block_height)

        # Lấy thời gian hiện tại
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        # Thông tin hệ thống
        cpu_load = run_shell("uptime | awk -F'load average:' '{ print $2 }' | sed 's/^ *//'")
        ram_used = int(run_shell("free -m | awk '/Mem:/ {print $3}'"))
        ram_total = int(run_shell("free -m | awk '/Mem:/ {print $2}'"))
        disk_usage = run_shell("df -h / | awk 'NR==2 {print $3 \"/\" $2 \" (\" $5 \" used)\"}'")

        # Trạng thái đồng bộ
        sync_status = "✅ <b>Synced</b>" if difference <= 1 else "❌ <b>Not Synced</b>"
        nodetype = get_governor_status()
        # Build HTML message
        html_message = (
            "<b>[Node Info]</b>\n"
            f"<b>Local block height:</b> {log_block_height}\n"
            f"<b>Network block height:</b> {latest_block_height}\n"
            f"<b>Difference:</b> {difference} blocks\n"
            f"<b>Sync status:</b> {sync_status}\n"
            f"<b>Node Type:</b> {nodetype}\n\n"
            "<b>[System Info]</b>\n"
            f"<b>CPU Load:</b> {cpu_load}\n"
            f"<b>RAM:</b> {ram_used}MB / {ram_total}MB\n"
            f"<b>Disk:</b> {disk_usage}"
        )

        return html_message

    except Exception as e:
        return f"<b>Exception: Error gathering status:</b> {str(e)}"