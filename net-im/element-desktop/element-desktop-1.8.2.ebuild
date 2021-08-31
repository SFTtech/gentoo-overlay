# Copyright 1999-2021 Gentoo Foundation
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


EAPI=7

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

inherit eutils desktop xdg-utils ${SCM}

LICENSE="Apache-2.0 MIT BSD"
SLOT="0"

IUSE="+native-extensions"
REQUIRED_USE=""
RESTRICT="network-sandbox"

# get dependencies via:
# readelf -a element-desktop | ag "Shared library" | ag -o '\[(.*)\]' | tr -d '[]' | while read lib; do qfile /usr/lib/$lib; done | cut -d: -f1 | sort | uniq
# libsecret is dlopen'd because of node-keytar
RDEPEND="
	!net-im/element-desktop-bin
	app-accessibility/at-spi2-atk:2
	app-crypt/libsecret
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	dev-libs/openssl
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/pango

	native-extensions? (
		dev-db/sqlcipher
	)

	=net-im/element-web-${PV}
"
DEPEND="
	${RDEPEND}
	sys-apps/yarn
	>=net-libs/nodejs-14.17.0
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
		yarn run build:native || die "native extensions build failed"
	fi

	yarn run build || die "build failed"
}


src_install() {
	dodoc LICENSE*
	insinto opt/${PN}
	exeinto opt/${PN}

	pushd ${S}/dist/linux-unpacked
	doins -r locales resources
	doins *.{pak,bin,dat}
	# `ldd element-desktop` says only libffmpeg.so is needed
	doins libffmpeg.so
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

	# symlink to main binary
	dosym ../../opt/${PN}/${PN} usr/bin/${PN}

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
