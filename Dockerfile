FROM runpod/worker-comfyui:5.5.1-base

WORKDIR /comfyui

# Copy extra_model_paths.yaml with correct absolute paths
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# Create startup script that symlinks was-ns from volume then starts ComfyUI
RUN printf '#!/bin/bash\nln -sf /runpod-volume/workspace/runpod-slim/ComfyUI/custom_nodes/was-ns /comfyui/custom_nodes/was-ns\nexec /start.sh' > /start_custom.sh && chmod +x /start_custom.sh

CMD ["/start_custom.sh"]
