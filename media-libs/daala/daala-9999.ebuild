# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://git.xiph.org/daala.git"
	AUTOTOOLS_AUTORECONF="1"
fi

inherit autotools-multilib ${SCM}

MY_P=${P/_/-}
DESCRIPTION="Open versatile video codec designed for ultra-high performance video compression"
HOMEPAGE="https://www.xiph.org/daala/"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
else
	SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
	)
	autotools-multilib_src_configure
}
