# Copyright 2014-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2 or later

EAPI=6
PYTHON_COMPAT=( python3_{6,7,8} )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/SFTtech/${PN}.git"
fi

CMAKE_MIN_VERSION=3.8.0
inherit cmake-utils python-single-r1 ${SCM}

DESCRIPTION="free as in freedom RTS engine for age of empires II TC"
HOMEPAGE="http://openage.sft.mx https://github.com/SFTtech/openage"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/SFTtech/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE="inotify tcmalloc profiling ncurses"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
${PYTHON_DEPS}
dev-qt/qtcore:5
dev-qt/qtdeclarative:5
dev-qt/qtquickcontrols:5
dev-cpp/eigen
dev-libs/nyan
media-fonts/dejavu
media-libs/fontconfig
media-libs/freetype:2[X]
media-libs/harfbuzz
media-libs/libepoxy
media-libs/libogg
media-libs/libpng
media-libs/libsdl2[X,opengl,video]
media-libs/opus
media-libs/opusfile
media-libs/sdl2-image[png]
virtual/opengl
tcmalloc? ( dev-util/google-perftools )
profiling? ( dev-util/google-perftools )
ncurses? ( sys-libs/ncurses )
$(python_gen_cond_dep '
    dev-python/numpy[${PYTHON_MULTI_USEDEP}]
    dev-python/pillow[${PYTHON_MULTI_USEDEP}]
    dev-python/toml[${PYTHON_MULTI_USEDEP}]
    dev-python/lz4[${PYTHON_MULTI_USEDEP}]
')
"
DEPEND="${RDEPEND}
|| ( >=sys-devel/clang-5.0.0 >=sys-devel/gcc-7.0.0 )
$(python_gen_cond_dep '
    dev-python/cython[${PYTHON_MULTI_USEDEP}]
    dev-python/jinja[${PYTHON_MULTI_USEDEP}]
    dev-python/pygments[${PYTHON_MULTI_USEDEP}]
')
"


src_configure() {
	local mycmakeargs=(
		-DWANT_INOTIFY="$(usex inotify True False)"
		-DWANT_GPERFTOOLS_TCMALLOC="$(usex tcmalloc True False)"
		-DWANT_GPERFTOOLS_PROFILER="$(usex profiling True False)"
		-DWANT_NCURSES="$(usex ncurses True False)"
	)

	cmake-utils_src_configure
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
