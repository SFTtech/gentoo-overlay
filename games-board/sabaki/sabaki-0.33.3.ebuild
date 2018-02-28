# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An elegant Go board and SGF editor for a more civilized age"
HOMEPAGE="http://sabaki.yichuanshen.de/"


if [[ ${PV} == "9999" ]]; then
	SCM="git-r3"

	SRC_URI=""
	EGIT_REPO_URI="https://github.com/SabakiHQ/Sabaki.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/SabakiHQ/Sabaki/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils ${SCM}

LICENSE="MIT"
SLOT="0"


# get dependencies via readelf -a sabaki...
DEPEND="
	sys-apps/yarn
	x11-libs/cairo
	x11-libs/pango
	media-libs/fontconfig
	gnome-base/gconf
	dev-libs/glib
"
RDEPEND="${DEPEND}"

DESTPATH="opt/${PN}"


QA_PREBUILT="
	${DESTPATH}/libffmpeg.so
	${DESTPATH}/libnode.so
	${DESTPATH}/${PN}
"

# capitalize first letter
S=${WORKDIR}/${PN^}-${PV}


src_prepare() {
	default
	yarn install || die "yarn module installation failed"
}


src_compile() {
	yarn run build || die "build failed"
}


src_install() {
	pushd ${S}/dist/linux-unpacked
	insinto ${DESTPATH}
	exeinto ${DESTPATH}
	dodoc LICENSE*
	doins -r locales resources
	doins *.{pak,bin,dat}
	doins *.so
	doexe ${PN}
	popd

	dosym ../../${DESTPATH}/${PN} usr/bin/${PN}
}
