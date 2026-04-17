FROM runpod/worker-comfyui:6.0.0-base

WORKDIR /comfyui

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

RUN printf '#!/bin/bash\necho "=== Checking volume ==="\nls /runpod-volume/workspace/runpod-slim/ComfyUI/custom_nodes/ || echo "Volume path not found"\necho "=== Symlinking was-ns ==="\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/custom_nodes/was-ns /comfyui/custom_nodes/was-ns\necho "=== Checking custom_nodes ==="\nls /comfyui/custom_nodes/\necho "=== Starting ComfyUI ==="\nexec /start.sh' > /start_custom.sh && chmod +x /start_custom.sh

CMD ["/start_custom.sh"]
