#!/bin/bash -e
sudo modprobe zram
echo "lz4" | sudo tee /sys/block/zram0/comp_algorithm
echo "$(echo '8 * 1024 * 1024 * 1024' | bc)" | sudo tee /sys/block/zram0/disksize
sudo mkswap /dev/zram0
sudo swapon /dev/zram0
