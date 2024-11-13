################################################################################
#
# XRP firmware
#
################################################################################

XRP_FIRMWARE_VERSION = $(XRP_VERSION)
XRP_FIRMWARE_SITE = $(XRP_SITE)
XRP_FIRMWARE_SOURCE = $(XRP_SOURCE)
XRP_FIRMWARE_LICENSE = MIT

define XRP_FIRMWARE_BUILD_CMDS
  XTENSA_SYSTEM="$(call qstrip,$(BR2_PACKAGE_XRP_FIRMWARE_XTENSA_SYSTEM))" \
  XTENSA_CORE="$(call qstrip,$(BR2_PACKAGE_XRP_FIRMWARE_DSP_CORE_NAME))" \
  $(MAKE) -j1 -C $(@D)/xrp-example XRP_DSP_USE_SRCS=1 XRP_DSP_HW_PORT=simple-xos CORE_NAME_PREFIX=DSP_ xrpdsp
endef

define XRP_FIRMWARE_INSTALL_TARGET_CMDS
  for (( CORE=0 ; CORE < $(BR2_PACKAGE_XRP_FIRMWARE_DSP_NUM_CORES); ++CORE )) ; do \
    $(INSTALL) -D -m 0644 $(@D)/xrp-example/xrp-dsp-standalone$${CORE} $(TARGET_DIR)/lib/firmware/xrp$${CORE}.elf ; \
  done
endef

$(eval $(generic-package))
