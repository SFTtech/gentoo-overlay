# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EAPI=6

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/kovidgoyal/${PN}.git"
fi

PYTHON_COMPAT=( python{3_5,3_6} )

inherit python-single-r1 ${SCM} desktop

DESCRIPTION="fast feature-full GPU-based terminal emulator"
HOMEPAGE="https://github.com/kovidgoyal/kitty"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/kovidgoyal/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
${PYTHON_DEPS}
media-libs/harfbuzz
dev-libs/libunistring
sys-libs/zlib
media-libs/libpng
media-libs/freetype
media-libs/fontconfig
media-gfx/imagemagick
dev-util/pkgconf
virtual/opengl
"
DEPEND="${RDEPEND}"


src_compile() {
	${EPYTHON} setup.py linux-package
}

src_install() {
	dobin linux-package/bin/kitty

	doicon -s 256 linux-package/share/icons/hicolor/256x256/apps/kitty.png
	domenu linux-package/share/applications/kitty.desktop

	insinto /usr/share/terminfo/x/
	doins linux-package/share/terminfo/x/xterm-kitty

	insinto /usr/lib/
	doins -r linux-package/lib/kitty/
}
