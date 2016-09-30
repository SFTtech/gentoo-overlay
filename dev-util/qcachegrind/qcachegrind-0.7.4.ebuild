# Distributed under the terms of the GNU General Public License v3 or later
# Author: Jonas Jelten <jj@sft.mx>

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit base qmake-utils python-single-r1

DESCRIPTION="call graph viewer for callgrind"
HOMEPAGE="https://kcachegrind.github.io/"
SLOT="0"

BUNDLENAME=kcachegrind

SRC_URI="http://kcachegrind.sourceforge.net/${BUNDLENAME}-${PV}.tar.gz"
S="${WORKDIR}/${BUNDLENAME}-${PV}"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
>=dev-util/valgrind-3.1
dev-qt/qtcore:5=
dev-qt/qtgui:5=
dev-qt/qtwidgets:5=
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/qt5qobject.patch"
}

src_configure() {
	#"${S}/qcg.pro"
	eqmake5
}

src_install() {
	exeinto /usr/bin/
	doexe cgview/cgview
	doexe qcachegrind/qcachegrind
	doexe converters/{dprof,hotshot,memprof,op,pprof}2calltree

	insinto /usr/share/applications/
	doins qcachegrind/qcachegrind.desktop

	insinto /usr/share/icons/hicolor/32x32/apps/
	newins kcachegrind/hi32-app-kcachegrind.png kcachegrind.png

	insinto /usr/share/icons/hicolor/48x48/apps/
	newins kcachegrind/hi48-app-kcachegrind.png kcachegrind.png

	python_fix_shebang "${ED}"
}

