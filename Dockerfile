FROM runpod/worker-comfyui:5.8.5-base
WORKDIR /comfyui
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

RUN comfy node install --exit-on-fail was-ns@3.0.1 --mode remote

RUN python -m pip install --no-cache-dir --upgrade pip \
 && python -m pip install --no-cache-dir opencv-python-headless \
 && rm -rf /root/.cache/pip

RUN printf '#!/bin/bash\n\
echo "=== DEBUG: filesystem ==="\n\
ls -lah /runpod-volume || true\n\
ls -lah /runpod-volume/runpod-slim || true\n\
ls -lah /runpod-volume/runpod-slim/ComfyUI || true\n
ls -lah /comfyui/models || true\n\
ls -lah /comfyui/models/upscale_models || true\n\
cat /comfyui/extra_model_paths.yaml || true\n\
echo "=== Creating symlinks ==="\n\
ln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/checkpoints /comfyui/models/checkpoints\n\
ln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/upscale_models /comfyui/models/upscale_models\n\
ln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/loras /comfyui/models/loras\n\
ln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/vae /comfyui/models/vae\n\
ln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/controlnet /comfyui/models/controlnet\n\
ln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/clip /comfyui/models/clip\n\
ln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/models/embeddings /comfyui/models/embeddings\n\
echo "=== Starting ComfyUI ==="\n\
exec /start.sh\n\
' > /start_custom.sh && chmod +x /start_custom.sh

ENTRYPOINT ["/start_custom.sh"]
