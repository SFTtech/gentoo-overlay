# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a minimalistic console hex editor with vim-like controls"
HOMEPAGE="https://home.in.tum.de/~panny/"
SRC_URI="https://home.in.tum.de/~panny/f/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dobin hyx
}
