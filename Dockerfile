FROM runpod/worker-comfyui:5.8.5-base

WORKDIR /comfyui

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# Remove incompatible was-ns and install fresh version
RUN rm -rf /comfyui/custom_nodes/was-ns && \
    comfy --workspace /comfyui node install was-node-suite-comfyui

# Pre-install opencv so was-node-suite doesn't try to install it at runtime
RUN pip install opencv-python-headless --upgrade

RUN printf '#!/bin/bash\nexec /start.sh' > /start_custom.sh && chmod +x /start_custom.sh

CMD ["/start_custom.sh"]
