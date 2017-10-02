# Detect proprietary NVIDIA
is_nvidia() {
    (glxinfo | grep "OpenGL vendor string:" | grep -q "NVIDIA Corporation")
    return $?
}
