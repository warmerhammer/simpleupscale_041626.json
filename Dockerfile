FROM runpod/worker-comfyui:5.8.5-base

WORKDIR /comfyui

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# Remove the incompatible built-in was-ns and install a compatible version
RUN rm -rf /comfyui/custom_nodes/was-ns && \
    comfy node install was-node-suite-comfyui

RUN printf '#!/bin/bash\nexec /start.sh' > /start_custom.sh && chmod +x /start_custom.sh

CMD ["/start_custom.sh"]
