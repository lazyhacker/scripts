#!/bin/bash

# ==========================================
# llama.cpp Podman Environment Setup Script
# ==========================================

# Prerequisite
#   sudo dnf install golang-github-nvidia-container-toolkit
#
#   # Generate the CDI spec file (this is required for Podman to detect the GPU)
#   sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml


# Configuration Variables
MODEL_DIR="$HOME/ai-models"
MODEL_FILENAME="gemma-4-E4B-it-Q8_0.gguf"
MODEL_URL="https://huggingface.co/ggml-org/gemma-4-12B-it-GGUF/resolve/main/gemma-4-12B-it-Q8_0.gguf"
NETWORK_NAME="ai-network"
CONTAINER_NAME="llama-server"
PORT="8080"

# Default Value
OPEN_FIREWALL="true"

# Parse Command-Line Arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-firewall)
            OPEN_FIREWALL="false"
            shift
            ;;
        --open-firewall)
            OPEN_FIREWALL="true"
            shift
            ;;
        *)
            echo "⚠️ Unknown argument: $1"
            echo "Usage: $0 [--open-firewall | --no-firewall]"
            exit 1
            ;;
    esac
done

echo "Starting llama.cpp Podman setup..."
echo "-----------------------------------"

# 1. Create the Podman network if it doesn't exist
echo "=> Checking network '$NETWORK_NAME'..."
if ! podman network exists "$NETWORK_NAME"; then
    echo "   Network not found. Creating '$NETWORK_NAME'..."
    podman network create "$NETWORK_NAME"
else
    echo "   Network '$NETWORK_NAME' already exists."
fi

# 2. Create the model directory if it doesn't exist
echo "=> Checking model directory..."
if [ ! -d "$MODEL_DIR" ]; then
    echo "   Directory not found. Creating '$MODEL_DIR'..."
    mkdir -p "$MODEL_DIR"
else
    echo "   Directory '$MODEL_DIR' already exists."
fi

# 3. Download the model if it hasn't been downloaded yet
echo "=> Checking for model file '$MODEL_FILENAME'..."
if [ ! -f "$MODEL_DIR/$MODEL_FILENAME" ]; then
    echo "   Model not found. Downloading (this may take a while)..."
    wget -c "$MODEL_URL" -O "$MODEL_DIR/$MODEL_FILENAME"
else
    echo "   Model already exists at $MODEL_DIR/$MODEL_FILENAME. Skipping download."
fi

# 4. Check for existing container and ask to recreate
if podman container exists "$CONTAINER_NAME"; then
    echo "=> Container '$CONTAINER_NAME' already exists."
    read -p "   Do you want to delete and recreate it? (y/N): " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "   Removing old container..."
        podman rm -f "$CONTAINER_NAME" >/dev/null 2>&1
    else
        echo "   Keeping old container configuration."
        podman rm -f "$CONTAINER_NAME" >/dev/null 2>&1
    fi
fi

# Get local IP to display to the user
HOST_IP=$(ip route get 1 2>/dev/null | awk '{print $7; exit}')

# ==========================================
# 5. Shared Container Arguments
# ==========================================
PODMAN_ARGS=(
  --name "$CONTAINER_NAME"
  --network "$NETWORK_NAME"
  --security-opt label=disable
  -p "${PORT}:${PORT}"
  -v "$MODEL_DIR:/models:z"
  --device nvidia.com/gpu=all
  ghcr.io/ggml-org/llama.cpp:server-cuda
  -m "/models/$MODEL_FILENAME"
  --host 0.0.0.0
  --port "$PORT"
  --n-gpu-layers 99
  -c 131072
)

# ==========================================
# 6. Execution Logic
# ==========================================

if [ "$OPEN_FIREWALL" = "true" ]; then
    
    # Define cleanup function for foreground mode
    cleanup() {
        echo ""
        echo "------------------------------------------------------------"
        echo "🛑 Shutting down and cleaning up..."
        echo "------------------------------------------------------------"
        
        echo "=> Closing firewall port ${PORT}/tcp..."
        sudo firewall-cmd --remove-port=${PORT}/tcp >/dev/null 2>&1
        
        if podman container exists "$CONTAINER_NAME"; then
            echo "=> Stopping container '$CONTAINER_NAME'..."
            podman stop "$CONTAINER_NAME" >/dev/null 2>&1
        fi
        
        echo "✅ Firewall closed and container stopped successfully."
        exit 0
    }

    # Register the cleanup function
    trap cleanup SIGINT SIGTERM EXIT

    echo "=> Opening firewall port ${PORT}/tcp for remote access..."
    sudo firewall-cmd --add-port=${PORT}/tcp

    echo "------------------------------------------------------------"
    echo "🚀 Starting llama.cpp Server in FOREGROUND"
    echo "------------------------------------------------------------"
    echo "Remote Web UI / API is now accessible at:"
    echo "  http://${HOST_IP}:${PORT}/"
    echo ""
    echo "Press Ctrl+C at any time to stop the server and close the firewall."
    echo "------------------------------------------------------------"

    # Start the Podman container in the foreground (--rm) passing the shared arguments
    podman run --rm "${PODMAN_ARGS[@]}"

else

    echo "------------------------------------------------------------"
    echo "🚀 Starting llama.cpp Server in BACKGROUND"
    echo "------------------------------------------------------------"
    echo "Local Web UI / API will be accessible at:"
    echo "  http://localhost:${PORT}/"
    echo "(Firewall modifications are disabled. Remote access is blocked by default.)"
    echo "------------------------------------------------------------"

    # Start the Podman container in the background (-d) passing the shared arguments
    podman run -d "${PODMAN_ARGS[@]}"
      
    echo "✅ Container is running in the background."
    echo "To view logs, run: podman logs -f $CONTAINER_NAME"
    echo "To stop the server, run: podman stop $CONTAINER_NAME"

fi
