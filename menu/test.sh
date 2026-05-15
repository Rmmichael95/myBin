#/usr/bin/env sh
overlay_kms_av1() {
    local DESK DESK
    DESK="$(pactl get-default-sink).monitor"
    MIC="$(pactl get-default-source)"

    ffmpeg -y \
        -threads:v 1 -threads:a 2 -filter_threads 1 -filter_complex_threads 1 \
        -init_hw_device drm=drm:/dev/dri/card0 \
        -init_hw_device vaapi=va@drm \
        -filter_hw_device va \
        \
        -f pulse -thread_queue_size 512 \
        -i "$DESK" \
        \
        -f pulse -thread_queue_size 512 \
        -i "$MIC" \
        \
        -device /dev/dri/card0 \
        -framerate 60 \
        -f kmsgrab -thread_queue_size 512 \
        -i - \
        \
        -f v4l2 -thread_queue_size 512 \
        -framerate 30 \
        -i /dev/video0 \
        \
        -filter_complex \
            '[0:a][1:a]amix=inputs=2:duration=longest:weights=1 1[audio];
             [2:v]hwmap,scale_vaapi=w=1920:h=1080:format=nv12[screen];
             [3:v]lut3d=/home/ryanm/.local/share/luts/35FreeLUTs/Azrael\ 93.CUBE:interp=tetrahedral,format=nv12,hwupload,scale_vaapi=w=320:h=240:format=nv12[cam];
             [screen][cam]overlay_vaapi=x=1588:y=830[out]' \
        \
        -map '[out]' \
        -map '[audio]' \
        \
        -c:v av1_vaapi -qp 128 \
        -c:a libopus -ac 2 -ar 48000 -b:a 320k \
        -strict -2 \
        "$HOME/videos/recording/overlay-$(date '+%y%m%d-%H%M-%S').mp4" &
    echo $! >/tmp/recording.pid
}
