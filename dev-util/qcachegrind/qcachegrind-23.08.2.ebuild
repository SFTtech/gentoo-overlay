# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/KDE/kcachegrind.git"
fi

inherit qmake-utils xdg-utils desktop ${SCM}

DESCRIPTION="graphical frontend for valgrind's callgrind profiler"
HOMEPAGE="https://kcachegrind.github.io/"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/KDE/kcachegrind/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
${PYTHON_DEPS}
dev-qt/qtbase:6[gui,opengl]
"
DEPEND="${RDEPEND}
"

S=${WORKDIR}/kcachegrind-${PV}

src_configure() {
	eqmake6
}

src_install() {
	einstalldocs

	doicon kcachegrind/kcachegrind.svg
	domenu qcachegrind/qcachegrind.desktop
	dobin qcachegrind/qcachegrind
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
