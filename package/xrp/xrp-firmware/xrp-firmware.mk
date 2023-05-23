################################################################################
#
# XRP firmware
#
################################################################################

XRP_FIRMWARE_VERSION = $(XRP_VERSION)
XRP_FIRMWARE_SITE = $(XRP_SITE)
XRP_FIRMWARE_SOURCE = $(XRP_SOURCE)
XRP_FIRMWARE_LICENSE = MIT

XRP_FIRMWARE_CONF_ENV = CC="xt-clang --xtensa-core=$(call qstrip,$(BR2_PACKAGE_$(PKG)_DSP_CORE_NAME))" AR="xt-ar --xtensa-core=$(call qstrip,$(BR2_PACKAGE_$(PKG)_DSP_CORE_NAME))" RANLIB="xt-ranlib --xtensa-core=$(call qstrip,$(BR2_PACKAGE_$(PKG)_DSP_CORE_NAME))"

XRP_FIRMWARE_CONF_OPTS = --disable-host --enable-dsp --enable-hosted --disable-standalone --disable-single

ifeq ($(BR2_PACKAGE_XRP_FIRMWARE_EXAMPLE),y)
XRP_FIRMWARE_CONF_OPTS += --enable-example
XRP_FIRMWARE_CONF_OPTS += --enable-port=simple-xos
#XRP_FIRMWARE_CONF_OPTS += CFLAGS=-DDEBUG
endif

define XRP_FIRMWARE_CONFIGURE_CMDS
	(cd $($(PKG)_SRCDIR) && rm -rf config.cache && \
	$($(PKG)_CONF_ENV) \
	XTENSA_SYSTEM="$(call qstrip,$(BR2_PACKAGE_$(PKG)_XTENSA_TOOLS))/../config" \
	PATH="$(call qstrip,$(BR2_PACKAGE_$(PKG)_XTENSA_TOOLS)):$$PATH" \
	CONFIG_SITE=/dev/null \
	./configure \
		--host=xtensa-elf \
		--prefix=/usr \
		--exec-prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--program-prefix="" \
		--disable-dependency-tracking \
		$(QUIET) $($(PKG)_CONF_OPTS) \
	)
endef

XRP_FIRMWARE_IMAGE_NAME = xrp-dsp-hosted

define XRP_FIRMWARE_BUILD_CMDS
  XTENSA_SYSTEM="$(call qstrip,$(BR2_PACKAGE_$(PKG)_XTENSA_TOOLS))/../config" \
  $(BR2_PACKAGE_$(PKG)_XTENSA_TOOLS)/../libexec/xt-mbuild \
	-root $(@D) -socfile $(BR2_PACKAGE_XRP_FIRMWARE_DSP_LSP_XTSYS) \
	-syspkg $(@D)/xrp-example/soc/package \
	-sysbuild $(@D)/xrp-example/soc/build \
	-preclean -build sw -lsps sim,sim-stacklocal ; \
  DSP_COMM_BASES=($(call qstrip,$(BR2_PACKAGE_$(PKG)_DSP_COMM_BASE))) ; \
  for (( CORE=0; CORE < $(BR2_PACKAGE_$(PKG)_DSP_NUM_CORES); ++CORE )) ; do \
    $(MAKE) \
	$($(PKG)_CONFIG-y) \
	XTENSA_SYSTEM="$(call qstrip,$(BR2_PACKAGE_$(PKG)_XTENSA_TOOLS))/../config" \
	PATH="$(call qstrip,$(BR2_PACKAGE_$(PKG)_XTENSA_TOOLS)):$$PATH" \
	-C $(@D) \
	DSP_LSP=`printf $(BR2_PACKAGE_$(PKG)_DSP_LSP) $${CORE}` \
	DSP_COMM_BASE=$${DSP_COMM_BASES[$${CORE}]} && \
    mv $(@D)/xrp-example/$($(PKG)_IMAGE_NAME){,$$CORE} ; \
  done
endef

define XRP_FIRMWARE_INSTALL_TARGET_CMDS
  for (( CORE=0 ; CORE < $(BR2_PACKAGE_$(PKG)_DSP_NUM_CORES); ++CORE )) ; do \
    $(INSTALL) -D -m 0644 $(@D)/xrp-example/$($(PKG)_IMAGE_NAME)$${CORE} $(TARGET_DIR)/lib/firmware/xrp$${CORE}.elf ; \
  done
endef

$(eval $(generic-package))
