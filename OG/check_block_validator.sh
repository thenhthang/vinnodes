#!/bin/bash

# ============================================
# Color Definitions
# ============================================
COLOR_GREEN='\033[1;32m'
COLOR_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[1;31m'
COLOR_MAGENTA='\033[1;35m'
COLOR_CYAN='\033[1;36m'
COLOR_WHITE='\033[1;37m'
COLOR_GRAY='\033[0;37m'
COLOR_RESET='\033[0m'

# ============================================
# Helper Functions
# ============================================

# Format number with commas for better readability
format_number() {
    printf "%'d" "$1" 2>/dev/null || echo "$1"
}

# Format sync status with colors and indicators
get_sync_status() {
    local diff=$1
    if [ $diff -le 2 ]; then
        echo -e "${COLOR_GREEN}[SYNCED]${COLOR_RESET}"
    elif [ $diff -le 10 ]; then
        echo -e "${COLOR_YELLOW}[SYNCING]${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}[BEHIND]${COLOR_RESET}"
    fi
}

# ============================================
# Load Environment Variables
# ============================================
if [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile"
fi
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

# ============================================
# Port Configuration & Detection (Prioritize Custom Port)
# ============================================

# --- OG Chain RPC ---
if [ -n "$OG_PORT" ]; then
    OG_CHAIN_RPC_PORT="${OG_PORT}657"
elif curl -s "http://localhost:26657/status" > /dev/null; then
    OG_CHAIN_RPC_PORT=26657
else
    read -p "0gchaind port not detected. Please enter the 0gchaind RPC port: " OG_CHAIN_RPC_PORT
fi

# --- Geth RPC ---
if [ -n "$OG_PORT" ]; then
    GETH_RPC_PORT="${OG_PORT}545"
elif curl -s -X POST \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  "http://localhost:8545" > /dev/null; then
    GETH_RPC_PORT=8545
else
    read -p "Geth port not detected. Please enter the Geth RPC port: " GETH_RPC_PORT
fi

PUBLIC_RPC_URL="https://evmrpc.0g.ai"

# Show configuration
echo -e "${COLOR_CYAN}==================================${COLOR_RESET}"
echo -e "${COLOR_CYAN}       0G Sync Monitor${COLOR_RESET}"
echo -e "${COLOR_GRAY}    Powered by${COLOR_RESET} ${COLOR_MAGENTA}AstroStake 🚀${COLOR_RESET}"
echo -e "${COLOR_CYAN}==================================${COLOR_RESET}"
echo -e "${COLOR_WHITE}Configuration:${COLOR_RESET} 0gchaind Port: ${COLOR_GREEN}$OG_CHAIN_RPC_PORT${COLOR_RESET} | Geth Port: ${COLOR_GREEN}$GETH_RPC_PORT${COLOR_RESET}"
echo -e "${COLOR_WHITE}Public RPC:${COLOR_RESET} $PUBLIC_RPC_URL"
echo -e "${COLOR_GRAY}$(printf '=%.0s' {1..80})${COLOR_RESET}"

# ============================================
# Initialization for ETA Calculation
# ============================================
prev_geth_height=0
prev_time=$(date +%s)
first_run=true

# ============================================
# Monitoring Loop
# ============================================
while true; do
    # 1. Fetch data from local 0gchaind (CL)
    og_status_json=$(curl -s "http://localhost:$OG_CHAIN_RPC_PORT/status")
    og_height=$(echo "$og_status_json" | jq -r '.result.sync_info.latest_block_height // "Error"')
    peers_count=$(curl -s "http://localhost:$OG_CHAIN_RPC_PORT/net_info" | jq -r '.result.n_peers // "0"')

    # 2. Fetch data from local Geth (EL)
    geth_response=$(curl -s -X POST "http://localhost:$GETH_RPC_PORT" -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}')
    geth_height=$(( $(echo "$geth_response" | jq -r '.result // "0x0"') ))

    # 3. Fetch data from the Public 0G RPC
    public_response=$(curl -s -X POST "$PUBLIC_RPC_URL" -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}')
    public_height=$(( $(echo "$public_response" | jq -r '.result // "0x0"') ))

    if [ "$og_height" = "Error" ] || [ "$geth_height" -eq 0 ]; then
        echo -e "${COLOR_RED}[$(date '+%H:%M:%S')] Failed to fetch local data. Check if nodes are running and ports are correct.${COLOR_RESET}"
        sleep 10
        continue
    fi

    # 4. Calculate differences, speed, and ETA
    local_diff=$((geth_height - og_height))
    network_diff=$((public_height - geth_height))
    current_time=$(date +%s)
    eta_display=""
    speed_display=""

    if [ "$first_run" = true ]; then
        first_run=false
    else
        time_diff=$((current_time - prev_time))
        height_diff=$((geth_height - prev_geth_height))

        if [ $time_diff -gt 0 ] && [ $height_diff -gt 0 ] && [ $network_diff -gt 0 ]; then
            speed=$(echo "scale=2; $height_diff / $time_diff" | bc 2>/dev/null || echo "0")
            if (( $(echo "$speed > 0" | bc -l) )); then
                speed_display="${COLOR_GRAY}(${speed} bl/s)${COLOR_RESET}"
                eta_seconds=$(echo "$network_diff / $speed" | bc 2>/dev/null || echo 0)
                eta_seconds=${eta_seconds%.*}
                if [ $eta_seconds -gt 0 ]; then
                    eta_formatted=$(printf '%02dh:%02dm:%02ds' $((eta_seconds/3600)) $((eta_seconds%3600/60)) $((eta_seconds%60)))
                    eta_display="| ${COLOR_YELLOW}ETA: ${eta_formatted}${COLOR_RESET}"
                fi
            fi
        fi
    fi
    
    # Save current state for the next loop's calculation
    prev_geth_height=$geth_height
    prev_time=$current_time
    
    # 5. Display information in a clean single line format
    timestamp=$(date '+%H:%M:%S')
    local_status=$(get_sync_status $local_diff)
    network_status=$(get_sync_status $network_diff)
    
    echo -e "${COLOR_GRAY}[$timestamp]${COLOR_RESET} ${COLOR_CYAN}LOCAL${COLOR_RESET}: Geth ${COLOR_GREEN}$(format_number $geth_height)${COLOR_RESET} | 0gchaind ${COLOR_BLUE}$(format_number $og_height)${COLOR_RESET} ${local_status} ${COLOR_GRAY}(diff:${local_diff})${COLOR_RESET} | ${peers_count} peers || ${COLOR_MAGENTA}NETWORK${COLOR_RESET}: $(format_number $public_height) ${network_status} ${COLOR_RED}(behind:$(format_number $network_diff))${COLOR_RESET} $speed_display $eta_display"

    sleep 5
done
