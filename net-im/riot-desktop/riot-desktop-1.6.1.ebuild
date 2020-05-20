# Copyright 1999-2020 Gentoo Foundation
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
#   net-im/riot-desktop networkaccess
#
# this avoids disabling `network-sandbox` globally.


EAPI=7

DESCRIPTION="A glossy Matrix collaboration client for desktop"
HOMEPAGE="https://riot.im"

MY_PV="${PV/_rc/-rc.}"
MY_P="$PN-$MY_PV"
S="${WORKDIR}/${MY_P}"

if [[ ${PV} == "9999" ]]; then
	SCM="git-r3"

	SRC_URI=""
	EGIT_REPO_URI="https://github.com/vector-im/riot-desktop.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/vector-im/riot-desktop/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils ${SCM}

LICENSE="Apache-2.0 MIT BSD"
SLOT="0"

IUSE="+native-extensions"
REQUIRED_USE=""

# get dependencies via readelf -a riot-desktop...
RDEPEND="
	x11-libs/cairo
	x11-libs/pango
	media-libs/fontconfig
	=net-im/riot-web-${PV}
"
DEPEND="
	${RDEPEND}
	sys-apps/yarn
	native-extensions? ( dev-db/sqlcipher virtual/rust )
"


src_prepare() {
	default

	sed -i 's@"https://packages.riot.im/desktop/update/"@null@g' ${S}/riot.im/release/config.json
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
	# `ldd riot-desktop` says only libffmpeg.so is needed
	doins libffmpeg.so
	doexe ${PN}
	popd

	# symlink to the actual webapp
	dosym ../../../usr/share/webapps/riot-web opt/${PN}/resources/webapp

	# config symlink
	dosym ../../../../etc/${PN}/config.json etc/webapps/riot-web/config.json
	insinto etc/${PN}
	doins ${S}/riot.im/release/config.json

	# symlink to main binary
	dosym ../../opt/${PN}/${PN} usr/bin/${PN}
}
