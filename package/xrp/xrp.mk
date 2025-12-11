################################################################################
#
# XRP
#
################################################################################

XRP_VERSION = 081f0010e5002d590a11473710e4872e9443df43
XRP_SITE = $(call github,foss-xtensa,xrp,$(XRP_VERSION))
XRP_SOURCE = xrp-$(XRP_VERSION).tar.gz
XRP_LICENSE = MIT, GPL

define XRP_BUILD_CMDS
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
