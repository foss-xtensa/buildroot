################################################################################
#
# XRP
#
################################################################################

XRP_VERSION = 2f5c7816aa47950fa25da6e850b9c68e4f385f7d
XRP_SITE = $(call github,foss-xtensa,xrp,$(XRP_VERSION))
XRP_SOURCE = xrp-$(XRP_VERSION).tar.gz
BR_NO_CHECK_HASH_FOR += $(XRP_SOURCE)
XRP_LICENSE = MIT, GPL

XRP_CONF_OPTS += --disable-dsp --disable-standalone --disable-single

ifeq ($(BR2_PACKAGE_XRP_USERSPACE),y)
XRP_CONF_OPTS += --enable-hosted
else
XRP_CONF_OPTS += --disable-hosted
endif

ifeq ($(BR2_PACKAGE_XRP_EXAMPLE),y)
XRP_CONF_OPTS += --enable-example
endif

HOST_XRP_CONF_OPTS = --disable-dsp --disable-single --disable-hosted

ifeq ($(BR2_PACKAGE_HOST_XRP),y)
HOST_XRP_CONF_OPTS += --enable-standalone
HOST_XRP_DEPENDENCIES += host-dtc
else
HOST_XRP_CONF_OPTS += --disable-standalone
endif

ifeq ($(BR2_PACKAGE_HOST_XRP_EXAMPLE),y)
HOST_XRP_CONF_OPTS += --enable-example
endif

XRP_MODULE_SUBDIRS = xrp-kernel
XRP_MODULE_MAKE_OPTS = CONFIG_XRP=m CONFIG_XRP_HW_SIMPLE=m
#XRP_MODULE_MAKE_OPTS += CONFIG_XRP_DEBUG=y

$(eval $(kernel-module))
$(eval $(autotools-package))
$(eval $(host-autotools-package))

include $(sort $(wildcard package/xrp/*/*.mk))
