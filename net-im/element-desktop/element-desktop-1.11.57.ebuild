# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NETWORK ACCESS
#
# this ebuild requires internet access! because javascript packaging.
#
# to allow network access just for this package:
#
# * /etc/portage/env/networkaccess:
#   FEATURES="${FEATURES} -network-sandbox"
#
# * /etc/portage/package.env/package.env:
#   net-im/element-desktop networkaccess
#
# this avoids disabling `network-sandbox` globally.


EAPI=8

DESCRIPTION="A glossy Matrix collaboration client for desktop"
HOMEPAGE="https://element.io"

MY_PV="${PV/_rc/-rc.}"
MY_P="$PN-$MY_PV"
TMP_P="element-desktop-$MY_PV"
S="${WORKDIR}/${TMP_P}"

if [[ ${PV} == "9999" ]]; then
	SCM="git-r3"

	SRC_URI=""
	EGIT_REPO_URI="https://github.com/vector-im/element-desktop.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/vector-im/element-desktop/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit desktop xdg-utils ${SCM}

LICENSE="Apache-2.0 MIT BSD"
SLOT="0"

IUSE="+native-extensions"
REQUIRED_USE=""
RESTRICT="network-sandbox"

# get dependencies via:
# readelf -a element-desktop | ag "Shared library" | ag -o '\[(.*)\]' | tr -d '[]' | while read lib; do qfile /usr/lib/$lib; done | cut -d: -f1 | sort | uniq
# don't use ldd - it would show you transitive dependencies!
#
# libsecret is dlopen'd because of node-keytar
RDEPEND="
	!net-im/element-desktop-bin
	=net-im/element-web-${PV}
	app-crypt/libsecret
	native-extensions? (
		dev-db/sqlcipher
	)

	app-accessibility/at-spi2-core
	dev-libs/expat
	dev-libs/glib
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtk+
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	sys-apps/yarn
	net-libs/nodejs
	native-extensions? (
		virtual/rust
	)
"

PATCHES=()


src_prepare() {
	default

	sed -i 's@"https://packages.riot.im/desktop/update/"@null@g' ${S}/element.io/release/config.json
	yarn install || die "yarn module installation failed"
}


src_compile() {
	if use native-extensions; then
		yarn run "build:native" || die "native extensions build failed"
	fi
	yarn run build || die "build failed"
}


src_install() {
	dodoc LICENSE*
	insinto opt/${PN}
	exeinto opt/${PN}

	# main executable launcher
	cat <<-EOF > "${S}/${PN}" || die
	#!/bin/bash

	# support wayland and x11
	exec ../../opt/${PN}/${PN} --ozone-platform-hint=auto \$@
	EOF
	dobin "${S}/${PN}"

	# electron files
	pushd ${S}/dist/linux-unpacked
	doins -r locales resources
	doins *.{pak,bin,dat,json}
	# `ldd element-desktop` says only libffmpeg.so is needed
	# but more libs are dlopened
	doins libffmpeg.so
	doins libGLESv2.so
	doins libEGL.so
	doins libvk_swiftshader.so
	doins libvulkan.so.1

	doexe chrome-sandbox
	doexe chrome_crashpad_handler
	doexe ${PN}
	popd

	# symlink to the actual webapp
	dosym ../../../usr/share/webapps/element-web opt/${PN}/resources/webapp

	# config symlink
	dosym /etc/${PN}/config.json etc/webapps/element-web/config.json
	insinto etc/${PN}
	doins ${S}/element.io/release/config.json

	# let's enable lab features!
	sed -ie 's/    "showLabsSettings": false/    "showLabsSettings": true/' $D/etc/$PN/config.json

	make_desktop_entry "/usr/bin/${PN}" Element element InstantMessaging

	# element:// url handler
	cat <<-EOF > "${S}/element-url-handler.desktop" || die
	[Desktop Entry]
	Name=Element - URL Handler
	Type=Application
	Exec=/usr/bin/${PN} %U
	Icon=${PN}
	NoDisplay=true
	StartupNotify=true
	Categories=InstantMessaging;
	MimeType=x-scheme-handler/element;
	EOF
	domenu "${S}/element-url-handler.desktop"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
