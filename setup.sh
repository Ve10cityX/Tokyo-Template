apt-get update -y
apt-get install -y ffmpeg libsm6 libxext6 aria2

COMFY_DIR="/workspace/ComfyUI"
if [ ! -d "$COMFY_DIR" ]; then
    COMFY_DIR="/comfyui"
fi

cd $COMFY_DIR/custom_nodes

install_node() {
    if [ ! -d "$(basename "$1" .git)" ]; then
        git clone "$1"
        if [ -f "$(basename "$1" .git)/requirements.txt" ]; then
            pip install -r "$(basename "$1" .git)/requirements.txt"
        fi
    fi
}

install_node "https://github.com/ltdrdata/ComfyUI-Manager.git"
install_node "https://github.com/Kijai/ComfyUI-WanVideoWrapper.git"
install_node "https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git"
install_node "https://github.com/rgthree/rgthree-comfy.git"
install_node "https://github.com/Kijai/ComfyUI-KJNodes.git"
install_node "https://github.com/yolain/ComfyUI-Easy-Use.git"
install_node "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git"
install_node "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git"
install_node "https://github.com/digital-processing/comfyui-propost.git"
install_node "https://github.com/evanspearman/ComfyMath.git"
install_node "https://github.com/crt-nodes/CRT-Nodes.git"
install_node "https://github.com/Kijai/ComfyUI-WanAnimatePreprocess.git"

pip install opencv-python imageio imageio-ffmpeg decord

HF_TOKEN="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"

dl_model() {
    if [ ! -f "$2/$3" ]; then
        aria2c --header="Authorization: Bearer $HF_TOKEN" -c -x 16 -s 16 -k 1M "$1" -d "$2" -o "$3"
    fi
}

mkdir -p $COMFY_DIR/models/loras
mkdir -p $COMFY_DIR/models/vae
mkdir -p $COMFY_DIR/models/clip
mkdir -p $COMFY_DIR/models/checkpoints

dl_model "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_animate_14B_relight_lora_bf16.safetensors" "$COMFY_DIR/models/loras" "wan2.2_animate14B_relight_lora_bf16.safetensors"
dl_model "https://huggingface.co/Kijai/WanVideo_comfy/resolve/e0af1f0ae35206c1fe5773b08190ded7a129b665/Lightx2v/lightx2v_T2V_14B_cfg_step_distill_v2_lora_rank256_bf16.safetensors" "$COMFY_DIR/models/loras" "lightx2vT2V14B_cfg_step_distillv2_lora_rank256_bf16.safetensors"
dl_model "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors" "$COMFY_DIR/models/loras" "wan2.2_iv_lightx2v_4steps_lora_v1_low_noise.safetensors"
dl_model "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Pusa/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors" "$COMFY_DIR/models/loras" "Wan2.1PusaLoRA14B_rank512_bf16.safetensors"
dl_model "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors" "$COMFY_DIR/models/vae" "Wan2_1_VAE_bf16.safetensors"
dl_model "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors" "$COMFY_DIR/models/clip" "umt5_xxl_fp16.safetensors"
dl_model "https://huggingface.co/alibaba-pai/Wan2.2-Fun-Reward-LoRAs/resolve/main/Wan2.2-Fun-A14B-InP-low-noise-MPS.safetensors" "$COMFY_DIR/models/checkpoints" "Wan2.2-Fun-A14B-Inp-low-noise-MPS.safetensors"
dl_model "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_animate_14B_bf16.safetensors" "$COMFY_DIR/models/checkpoints" "wan2.2_animate_14B_bf16.safetensors"

supervisorctl restart comfyui
