# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a minimalistic console hex editor with vim-like controls"
HOMEPAGE="https://yx7.cc/code/"
SRC_URI="https://yx7.cc/code/hyx/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dobin hyx
}
