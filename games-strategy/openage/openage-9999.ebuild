# Copyright 2014-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2 or later

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/SFTtech/${PN}.git"
fi

inherit cmake python-single-r1 ${SCM}

DESCRIPTION="free as in freedom RTS engine for age of empires II TC"
HOMEPAGE="http://openage.dev https://github.com/SFTtech/openage"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/SFTtech/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE="inotify tcmalloc debug ncurses backtrace"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
${PYTHON_DEPS}
dev-qt/qtbase:6[gui,opengl]
dev-qt/qtdeclarative:6
dev-cpp/eigen
dev-libs/nyan
media-fonts/dejavu
media-libs/fontconfig
media-libs/freetype:2[X]
media-libs/harfbuzz
media-libs/libepoxy
media-libs/libogg
media-libs/libpng
media-libs/opus
media-libs/opusfile
virtual/opengl
tcmalloc? ( dev-util/google-perftools )
debug? ( dev-util/google-perftools )
ncurses? ( sys-libs/ncurses )
backtrace? ( sys-libs/libbacktrace )
$(python_gen_cond_dep '
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/lz4[${PYTHON_USEDEP}]
')
"
DEPEND="${RDEPEND}
|| ( >=sys-devel/clang-13.0.0 >=sys-devel/gcc-11.0.0 )
$(python_gen_cond_dep '
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
')
"


src_configure() {
	local mycmakeargs=(
		-DWANT_INOTIFY="$(usex inotify True False)"
		-DWANT_GPERFTOOLS_TCMALLOC="$(usex tcmalloc True False)"
		-DWANT_GPERFTOOLS_PROFILER="$(usex debug True False)"
		-DWANT_NCURSES="$(usex ncurses True False)"
		-DWANT_BACKTRACE="$(usex backtrace True False)"
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
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
