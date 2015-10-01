# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="Library to deal with DWARF Debugging Information Format"
HOMEPAGE="http://www.prevanders.net/dwarf.html"
SRC_URI="http://www.prevanders.net/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/dwarf-${PV}"

# dirty hack, since I can't properly patch buildsystem
QA_PREBUILT="*/${PN}.so"

src_prepare() {
	epatch "${FILESDIR}/fix_libdwarf_rpath.patch"

	epatch_user
}

src_configure() {
	econf --enable-shared
}

src_install() {
	pushd libdwarf
	dolib.a libdwarf.a || die
	dolib.so libdwarf.so || die

	insinto /usr/include/libdwarf/
	doins libdwarf.h || die
	doins dwarf.h || die
	popd

	dodoc NEWS README || die
}
