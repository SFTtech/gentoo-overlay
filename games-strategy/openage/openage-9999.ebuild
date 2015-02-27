# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/SFTtech/openage.git https://github.com/SFTtech/openage.git"
fi

CMAKE_MIN_VERSION=2.8.10
inherit cmake-utils games ${SCM}

DESCRIPTION="free as in freedom RTS engine for age of empires II TC"
HOMEPAGE="http://openage.sft.mx https://github.com/SFTtech/openage"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
else
	SRC_URI="https://github.com/SFTtech/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
REQUIRED_USE=""

RDEPEND="
>=dev-lang/python-3.3:=
dev-python/pillow
dev-python/numpy
virtual/opengl
media-libs/glew:=
media-libs/ftgl:=
media-fonts/dejavu
media-libs/freetype:2=[X]
media-libs/fontconfig:=
media-libs/libsdl2:=[X,opengl,video]
media-libs/sdl2-image:=[png]
media-libs/opusfile:=
"
DEPEND="${RDEPEND}
|| ( >=sys-devel/clang-3.4 >=sys-devel/gcc-4.9 )
"

# we're utilizing the cmake eclass:
# https://devmanual.gentoo.org/eclass-reference/cmake-utils.eclass/index.html

BUILD_DIR="${WORKDIR}/${P}_build"

CMAKE_MAKEFILE_GENERATOR="emake" # -> ninja?

pkg_setup() {
	games_pkg_setup
}

src_prepare() {
	# packaged patches:
	#PATCHES=(
	#)

	# user patches:
	epatch_user

	# already includes epatch_user:
	cmake-utils_src_prepare
}

src_configure() {
	#local mycmakeargs=(
	#
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	# xdg desktop entries. TODO: icon!
	make_desktop_entry "${PN}" "openage"

	# file permissions
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	einfo "To run openage, you need to have the original media files!"
	einfo "You will be asked to convert them on the first run."
	einfo " ___________________________"
	einfo "< openage! awesome! MOOOOO! >"
	einfo " ---------------------------"
	einfo "          \\   ^__^"
	einfo "           \\  (oo)\\_______"
	einfo "              (__)\\       )\\/\\"
	einfo "                  ||----w |"
	einfo "                  ||     ||"
}

