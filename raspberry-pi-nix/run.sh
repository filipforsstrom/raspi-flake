#!/usr/bin/env bash

# Function to handle SIGINT (Ctrl+C)
cleanup() {
    echo "Caught SIGINT signal! Terminating QEMU..."
    kill -SIGINT "$qemu_pid"
    wait "$qemu_pid"
}

# Trap SIGINT and call cleanup function
trap cleanup SIGINT

# Run QEMU in the background
qemu-system-aarch64 -machine raspi4b \
            -cpu cortex-a72 \
            -m 2G \
            -smp 4 \
            -kernel kernel.img \
            -dtb bcm2711-rpi-4-b.dtb \
            -drive "file=aarch64-qemu.img,format=raw,index=0,media=disk" \
            -append "rw earlyprintk loglevel=8 console=ttyAMA1,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk1p2 rootdelay=1" \
            -usb \
            -device usb-mouse \
            -device usb-kbd \
            -device usb-net,netdev=net0 \
            -serial mon:stdio \
            -netdev user,id=net0,hostfwd=tcp::7777-:22 &


# Get the PID of the QEMU process
qemu_pid=$!

# Wait for the QEMU process to finish
wait "$qemu_pid"