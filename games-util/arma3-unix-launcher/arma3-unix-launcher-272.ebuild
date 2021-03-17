# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Launcher for ARMA3 with mod support"
HOMEPAGE="https://github.com/muttleyxd/arma3-unix-launcher"
SRC_URI="https://github.com/muttleyxd/arma3-unix-launcher/archive/commit-${PV}.tar.gz -> ${P}.tar.gz"

PATCHES=(
	"${FILESDIR}/fix-argparse.patch"
	"${FILESDIR}/use-system-libfmt.patch"
)

inherit cmake

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}-commit-${PV}"

DEPEND="
	dev-libs/pugixml
	dev-libs/libfmt
	dev-libs/pugixml
	dev-cpp/argparse
	>=dev-qt/qtwidgets-5.9:5
	>=dev-qt/qtsvg-5.9:5
	>=dev-qt/qtcore-5.9:5
"
RDEPEND="${DEPEND}"
BDEPEND=""

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
