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
#   net-im/element-web networkaccess
#
# this avoids disabling `network-sandbox` globally.


EAPI=7

DESCRIPTION="A glossy Matrix collaboration client for the web"
HOMEPAGE="https://element.io/"

MY_PV="${PV/_rc/-rc.}"
MY_P="$PN-$MY_PV"
TMP_P="element-web-$MY_PV"
S="${WORKDIR}/${TMP_P}"

if [[ ${PV} == "9999" ]]; then
	SCM="git-r3"

	SRC_URI=""
	EGIT_REPO_URI="https://github.com/vector-im/element-web.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/vector-im/element-web/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

# TODO: inherit from webapp
inherit eutils desktop ${SCM}


LICENSE="Apache-2.0 MIT BSD"
SLOT="0"
IUSE=""
REQUIRED_USE=""

# maybe nodejs version needs to be limited according to these compatibilities:
# https://github.com/node-gfx/node-canvas-prebuilt/releases
# https://nodejs.org/en/download/releases/
RDEPEND="
	net-libs/nodejs
	x11-libs/cairo
	x11-libs/pango
	media-libs/fontconfig
"
DEPEND="${RDEPEND}
	sys-apps/yarn
"


src_prepare() {
	default
	yarn install || die "yarn module installation failed"

	if [[ ${PV} == "9999" ]]; then
		pushd ${S}/node_modules/
		rm -rf matrix-js-sdk
		git clone https://github.com/matrix-org/matrix-js-sdk --branch develop
		pushd matrix-js-sdk
		yarn install
		popd
		popd
	fi

	if [[ ${PV} == "9999" ]]; then
		pushd ${S}/node_modules/
		rm -rf matrix-react-sdk
		git clone https://github.com/matrix-org/matrix-react-sdk --branch develop
		pushd matrix-react-sdk
		yarn install
		popd
		popd
	fi
}


src_compile() {
	yarn run build || die "build failed"
}


src_install() {
	insinto usr/share/webapps/${PN}
	dodoc LICENSE*
	doins -r webapp/*

	insinto etc/webapps/${PN}
	doins config.sample.json
	dosym /etc/webapps/${PN}/config.json usr/share/webapps/${PN}/config.json

	newicon res/themes/element/img/logos/element-logo.svg element.svg
}


pkg_postinst() {
	einfo "element-web only contains a static webapp"
	einfo "for the electron-executable, please install element-desktop"
}
