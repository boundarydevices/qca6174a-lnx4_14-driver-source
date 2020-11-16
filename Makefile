KERNEL_SRC ?= /lib/modules/$(shell uname -r)/build

# Determine if the driver license is Open source or proprietary
# This is determined under the assumption that LICENSE doesn't change.
# Please change here if driver license text changes.
LICENSE_FILE ?= $(PWD)/$(WLAN_ROOT)/CORE/HDD/src/wlan_hdd_main.c
WLAN_OPEN_SOURCE = $(shell if grep -q "MODULE_LICENSE(\"Dual BSD/GPL\")" \
		$(LICENSE_FILE); then echo 1; else echo 0; fi)

#By default build for CLD
KBUILD_OPTIONS := WLAN_ROOT=$(PWD)
KBUILD_OPTIONS += MODNAME?=wlan
KBUILD_OPTIONS += CONFIG_NON_QC_PLATFORM=y
KBUILD_OPTIONS += CONFIG_ROME_IF=pci
KBUILD_OPTIONS += CONFIG_WLAN_FEATURE_11W=y
KBUILD_OPTIONS += CONFIG_WLAN_FEATURE_FILS=y
KBUILD_OPTIONS += CONFIG_WLAN_WAPI_MODE_11AC_DISABLE=y
KBUILD_OPTIONS += CONFIG_QCA_CLD_WLAN=m
KBUILD_OPTIONS += WLAN_OPEN_SOURCE=$(WLAN_OPEN_SOURCE)
KBUILD_OPTIONS += $(KBUILD_EXTRA) # Extra config if any

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(shell pwd) modules $(KBUILD_OPTIONS)

modules_install:
	$(MAKE) INSTALL_MOD_STRIP=1 -C $(KERNEL_SRC) M=$(shell pwd) modules_install

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) clean
