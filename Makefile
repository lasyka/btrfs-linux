#
# Makefile for the linux btrfs filesystem driver.
#
export CONFIG_BTRFS_FS=m
export CONFIG_BTRFS_FS_POSIX_ACL=y
export CONFIG_BTRFS_FS_CHECK_INTEGRITY=y

obj-$(CONFIG_BTRFS_FS) := btrfs.o

btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
	   file-item.o inode-item.o inode-map.o disk-io.o \
	   transaction.o inode.o file.o tree-defrag.o \
	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o

btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o

KERNELRELEASE   ?= $(shell uname -r)
KDIR    ?= /lib/modules/${KERNELRELEASE}/build
MDIR    ?= /lib/modules/${KERNELRELEASE}
PWD     := $(shell pwd)

all:
        $(MAKE) CFLAGS_MODULE=-fno-pic -C $(KDIR) M=$(PWD) modules

clean:
        $(MAKE) -C $(KDIR) M=$(PWD) clean

help:
        $(MAKE) -C $(KDIR) M=$(PWD) help

install: btrfs.ko
        rm -f ${MDIR}/kernel/fs/btrfs/btrfs.ko
        install -m644 -b -D btrfs.ko ${MDIR}/kernel/fs/btrfs/btrfs.ko
        depmod -aq

uninstall:
        rm -rf ${MDIR}/kernel/fs/btrfs
        depmod -aq
