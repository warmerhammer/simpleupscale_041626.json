FROM runpod/worker-comfyui:5.8.5-base

WORKDIR /comfyui

# Remove incompatible was-ns and install fresh version
RUN rm -rf /comfyui/custom_nodes/was-ns && \
    comfy --workspace /comfyui node install was-node-suite-comfyui

# Pre-install opencv
RUN pip install opencv-python-headless --upgrade

RUN printf '#!/bin/bash\necho "=== Waiting for volume ==="\nwhile [ ! -d /runpod-volume/workspace/runpod-slim/ComfyUI/models ]; do\n  echo "Waiting for volume..."\n  sleep 1\ndone\necho "=== Creating symlinks ==="\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/checkpoints /comfyui/models/checkpoints\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/upscale_models /comfyui/models/upscale_models\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/loras /comfyui/models/loras\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/vae /comfyui/models/vae\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/controlnet /comfyui/models/controlnet\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/clip /comfyui/models/clip\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/embeddings /comfyui/models/embeddings\necho "=== Starting ComfyUI ==="\nexec /start.sh' > /start_custom.sh && chmod +x /start_custom.sh

CMD ["/start_custom.sh"]
