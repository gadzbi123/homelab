# Check file system for ext2/ext3/ext4 partition
sudo e2fsck -fcp /dev/sdXN

# Check file system for boot partition
sudo fsck -a /dev/sdXN
