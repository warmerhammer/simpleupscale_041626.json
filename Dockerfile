FROM runpod/worker-comfyui:5.8.5-base

WORKDIR /comfyui

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# Remove incompatible was-ns and install fresh version
RUN comfy node install --exit-on-fail was-ns@3.0.1 --mode remote

RUN python -m pip install --no-cache-dir --upgrade pip \
 && python -m pip install --no-cache-dir opencv-python-headless \
 && rm -rf /root/.cache/pip

RUN printf '#!/bin/bash\n echo "=== DEBUG: filesystem ==="
ls -lah /runpod-volume || true
ls -lah /runpod-volume/workspace || true
ls -lah /comfyui/models || true
ls -lah /comfyui/models/upscale_models || true
cat /comfyui/extra_model_paths.yaml || true echo "=== Creating symlinks ==="\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/checkpoints /comfyui/models/checkpoints\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/upscale_models /comfyui/models/upscale_models\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/loras /comfyui/models/loras\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/vae /comfyui/models/vae\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/controlnet /comfyui/models/controlnet\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/clip /comfyui/models/clip\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/embeddings /comfyui/models/embeddings\necho "=== Starting ComfyUI ==="\nexec /start.sh' > /start_custom.sh && chmod +x /start_custom.sh

CMD ["/start_custom.sh"]
