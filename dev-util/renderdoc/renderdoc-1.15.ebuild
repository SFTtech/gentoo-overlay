# Copyright 2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EAPI=7

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/baldurk/renderdoc.git"
	EGIT_BRANCH="v1.x"
fi

PYTHON_COMPAT=( python3_{7,8,9,10} )

CMAKE_MIN_VERSION=3.1.0
inherit ${SCM} qmake-utils cmake-multilib eutils python-single-r1 xdg-utils


DESCRIPTION="A tool for tracing, analyzing, and debugging graphics APIs"
HOMEPAGE="https://renderdoc.org/ https://github.com/baldurk/renderdoc"

# as defined by RENDERDOC_SWIG_PACKAGE
# in qrenderdoc/CMakeLists.txt
SWIGDIR="${WORKDIR}/swig-renderdoc-modified-7"
SWIGDL="https://github.com/baldurk/swig/archive/renderdoc-modified-7.tar.gz -> ${P}-swig7.tar.gz"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI="qt5? ( ${SWIGDL} )"
	KEYWORDS=""
else
	SRC_URI="qt5? ( ${SWIGDL} ) https://github.com/baldurk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="MIT"
SLOT="0"
IUSE="+qt5 +python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
x11-libs/libX11
x11-libs/libxcb
x11-libs/xcb-util-keysyms
dev-libs/libpcre
virtual/opengl
python? (
	${PYTHON_DEPS}
)
qt5? (
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	$(python_gen_cond_dep '
	dev-python/shiboken2[${PYTHON_USEDEP}]
	')
	dev-python/pyside2
)
"
DEPEND="${RDEPEND}
sys-devel/bison
"

PATCHES="
${FILESDIR}/fix-deprecated-list-access.patch
${FILESDIR}/gentoo-release-build.patch
"


src_prepare() {
	cmake-utils_src_prepare

	# Vulkan library -> multilib
	sed -i "${S}/renderdoc/driver/vulkan/renderdoc.json" \
		-e "s/@VULKAN_LAYER_MODULE_PATH@/librenderdoc.so/g" || die
}

multilib_src_configure() {
	if multilib_is_native_abi; then
		local mycmakeargs=(
			-DENABLE_QRENDERDOC="$(usex qt5 ON OFF)"
			-DENABLE_PYRENDERDOC="$(usex python ON OFF)"
			-DPython3_EXECUTABLE="${PYTHON}"
			# for Shiboken2Config.cmake
			-DPYTHON_CONFIG_SUFFIX="-python$(${PYTHON} -c 'import sys; print("%d.%d" % (sys.version_info[0], sys.version_info[1]), end="")')"
			-DRENDERDOC_SWIG_PACKAGE="${SWIGDIR}"
		)
	else
		local mycmakeargs=(
			-DENABLE_QRENDERDOC=OFF
			-DENABLE_PYRENDERDOC=OFF
		)
	fi

	cmake-utils_src_configure
}

multilib_src_install_all() {
	dodoc ${D}/usr/share/doc/renderdoc/*
	dodoc util/LINUX_DIST_README
	rm -r ${D}/usr/share/doc/renderdoc
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
