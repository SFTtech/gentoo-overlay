# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="QPxTool is the linux way to get full control over your CD/DVD drives"
HOMEPAGE="https://qpxtool.sourceforge.io/"
SRC_URI="mirror://sourceforge/qpxtool/qpxtool/0.8.x/0.8.1/qpxtool-0.8.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/qpxtool-0.8.1-pointer-comparison.patch" )

DEPEND="
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	./configure --prefix=/usr --mandir=/usr/share/man --libdir=/usr/lib64
}

src_install() {

	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
		emake -j1 DESTDIR="${D}" install
	fi

	if ! declare -p DOCS >/dev/null 2>&1 ; then
		local d
		for d in README* ChangeLog AUTHORS NEWS TODO CHANGES THANKS BUGS \
				FAQ CREDITS CHANGELOG ; do
			[[ -s "${d}" ]] && dodoc "${d}"
		done
	elif [[ $(declare -p DOCS) == "declare -a"* ]] ; then
		dodoc "${DOCS[@]}"
	else
		dodoc ${DOCS}
	fi
}


