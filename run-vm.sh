#!/bin/bash

usage() {
    echo ""
    echo "Usage: $0 [ioda|nonioda]"
    echo ""
    exit
}

IODA_IMGDIR="./images/"
IODA_KERNEL="src/iodaLinux/arch/x86/boot/bzImage"
IODA_FEMU="src/iodaFEMU/build-femu/x86_64-softmmu/qemu-system-x86_64"

echo 2 | sudo tee /sys/kernel/mm/ksm/run >/dev/null 2>&1

echo "===> Booting the IODA Virtual Machine..."
sleep 3

    #-kernel "${IODA_KERNEL}" \
    #-append "root=/dev/sda1 console=ttyS0,115200n8 console=tty0 biosdevname=0 net.ifnames=0 nokaslr log_buf_len=128M loglevel=4" \

sudo ${IODA_FEMU} \
    -name "iodaVM" \
    -cpu host \
    -smp 24 \
    -m 16G \
    -enable-kvm \
    -boot menu=on \
    -drive file=${IODA_IMGDIR}/ioda.qcow2,if=virtio,cache=none,aio=native,format=qcow2 \
    -device femu,devsz_mb=12288,femu_mode=1 \
    -device femu,devsz_mb=12288,femu_mode=1 \
    -device femu,devsz_mb=12288,femu_mode=1 \
    -device femu,devsz_mb=12288,femu_mode=1 \
    -netdev user,id=user0,hostfwd=tcp::10101-:22 \
    -device virtio-net-pci,netdev=user0 \
    -nographic | tee ./ioda-femu.log 2>&1 \
