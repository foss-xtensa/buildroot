################################################################################
#
# XRP
#
################################################################################

XRP_VERSION = 189808909f625f2c7b724cb9dabe0e95d606ce6d
XRP_SITE = $(call github,foss-xtensa,xrp,$(XRP_VERSION))
XRP_SOURCE = xrp-$(XRP_VERSION).tar.gz
XRP_LICENSE = MIT, GPL

define XRP_BUILD_CMDS
  XTENSA_SYSTEM="$(call qstrip,$(BR2_PACKAGE_XRP_FIRMWARE_XTENSA_SYSTEM))" \
  XTENSA_CORE="$(call qstrip,$(BR2_PACKAGE_XRP_FIRMWARE_DSP_CORE_NAME))" \
  $(MAKE) -j1 $(TARGET_CONFIGURE_OPTS) -C $(@D)/xrp-example xrphosted
endef

define XRP_INSTALL_TARGET_CMDS
  $(INSTALL) -D -m 0755 $(@D)/xrp-example/xrp-host-hosted $(TARGET_DIR)/usr/bin/
endef

XRP_MODULE_SUBDIRS = xrp-kernel
XRP_MODULE_MAKE_OPTS = CONFIG_XRP=m CONFIG_XRP_HW_SIMPLE=m
#XRP_MODULE_MAKE_OPTS += CONFIG_XRP_DEBUG=y

$(eval $(kernel-module))
$(eval $(generic-package))

include $(sort $(wildcard package/xrp/*/*.mk))
