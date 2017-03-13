# Copyright 2014-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/SFTtech/${PN}.git https://github.com/SFTtech/${PN}.git"
fi

CMAKE_MIN_VERSION=3.1.0
inherit cmake-utils python-single-r1 ${SCM}

DESCRIPTION="free as in freedom RTS engine for age of empires II TC"
HOMEPAGE="http://openage.sft.mx https://github.com/SFTtech/openage"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/SFTtech/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE="inotify tcmalloc profiling"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
${PYTHON_DEPS}
dev-python/pillow[${PYTHON_USEDEP}]
dev-python/numpy[${PYTHON_USEDEP}]
virtual/opengl
media-libs/libepoxy:=
media-libs/harfbuzz:=
media-fonts/dejavu
media-libs/freetype:2=[X]
media-libs/fontconfig:=
media-libs/libsdl2:=[X,opengl,video]
media-libs/sdl2-image:=[png]
media-libs/opusfile:=
media-sound/opus-tools
>=dev-qt/qtcore-5.5
>=dev-qt/qtdeclarative-5.5
>=dev-qt/qtquickcontrols-5.5
tcmalloc? ( dev-util/google-perftools )
profiling? ( dev-util/google-perftools )
"
DEPEND="${RDEPEND}
dev-python/cython[${PYTHON_USEDEP}]
dev-python/pygments[${PYTHON_USEDEP}]
|| ( >=sys-devel/clang-3.4 >=sys-devel/gcc-4.9 )
"

# we're utilizing the cmake eclass:
# https://devmanual.gentoo.org/eclass-reference/cmake-utils.eclass/index.html

BUILD_DIR="${WORKDIR}/${P}_build"

CMAKE_MAKEFILE_GENERATOR="emake"

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
	local mycmakeargs=(
		-DWANT_INOTIFY="$(usex inotify True False)"
		-DWANT_GPERFTOOLS_TCMALLOC="$(usex tcmalloc True False)"
		-DWANT_GPERFTOOLS_PROFILER="$(usex profiling True False)"
	)

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
}

pkg_postinst() {
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
