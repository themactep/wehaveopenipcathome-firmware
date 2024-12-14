FAAC_SITE_METHOD = git
FAAC_SITE = https://github.com/knik0/faac
FAAC_SITE_BRANCH = master
FAAC_VERSION = $(shell git ls-remote $(FAAC_SITE) $(FAAC_SITE_BRANCH) | head -1 | cut -f1)

FAAC_LICENSE = MPEG-4-Reference-Code, LGPL-2.1+
FAAC_LICENSE_FILES = COPYING

FAAC_INSTALL_STAGING = YES
FAAC_INSTALL_TARGET = NO

FAAC_AUTORECONF = YES
FAAC_DEPENDENCIES += host-pkgconf host-libtool

FAAC_CONF_OPTS = --prefix=/usr --enable-static --disable-shared

FAAC_LDFLAGS = $(TARGET_LDFLAGS) -z max-page-size=0x1000
FAAC_CONF_ENV = PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" LDFLAGS="$(FAAC_LDFLAGS)"

define FAAC_CONFIGURE_CMDS
	(cd $(FAAC_SRCDIR) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(FAAC_CONF_ENV) \
	./configure \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--target=$(GNU_TARGET_NAME) \
		$(FAAC_CONF_OPTS) \
	)
endef

define FAAC_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/usr/lib
	$(INSTALL) -m 0755 -D $(@D)/libfaac/.libs/libfaac.a $(TARGET_DIR)/usr/lib/
endef

define FAAC_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0755 -D $(@D)/libfaac/.libs/libfaac.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 0644 -D $(@D)/include/faac.h $(STAGING_DIR)/usr/include/faac.h
	$(INSTALL) -m 0644 -D $(@D)/include/faaccfg.h $(STAGING_DIR)/usr/include/faaccfg.h
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
