# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

WORKDIR /comfyui

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
RUN comfy node install --exit-on-fail was-ns@3.0.1 --mode remote
# Could not resolve unknown_registry PrimitiveNode (no aux_id) - skipping

# download models into comfyui
RUN comfy model download --url https://huggingface.co/nateraw/real-esrgan/blob/44ad8adf6069185b86df22349b12f255821c86ab/RealESRGAN_x4plus_anime_6B.pth --relative-path models/upscale_models --filename realesrganX4plusAnime_v1.pt

# Install Python deps if provided
RUN if [ -f /comfyui/custom_nodes/was-ns/requirements.txt ]; then \
      pip install --no-cache-dir -r /comfyui/custom_nodes/was-ns/requirements.txt; \
    fi

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
