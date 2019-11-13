# Copyright 2014-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2 or later

EAPI=6

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/Andersbakken/rtags.git"
	EGIT_BRANCH="develop"
fi

CMAKE_MIN_VERSION=3.1.0
inherit systemd cmake-utils elisp-common ${SCM}

DESCRIPTION="C/C++ indexer for Emacs based on clang"
HOMEPAGE="https://github.com/Andersbakken/rtags"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/Andersbakken/rtags/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE="+emacs systemd"
REQUIRED_USE=""

RDEPEND="
>=sys-devel/clang-3.3
emacs? ( >=virtual/emacs-24 )
"
DEPEND="${RDEPEND}
"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	# this allows to disable emacs usage and bash-completion installation
	${FILESDIR}/optional-components.patch
)

pkg_setup () {
	elisp-need-emacs 24.3 || die "Emacs version too low"
}


src_configure() {
	local mycmakeargs=(
		-DEMACS="DUMMY"  # prevent buildsystem from elisp compiling
		-DINSTALL_BASH_COMPLETION=OFF
	)

	cmake-utils_src_configure
}


src_compile() {
	cmake-utils_src_compile

	# should do what the buildsystem tries to do
	if use emacs; then
		local BYTECOMPFLAGS="-l src/compile-shim.elisp -l src/rtags.el"
		elisp-compile src/*rtags.el
	fi
}


src_install() {
	cmake-utils_src_install

	if use emacs; then
		elisp-install ${PN} src/*rtags.el src/*rtags.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use systemd; then
		systemd_douserunit ${FILESDIR}/rdm.{service,socket}
	fi
}


pkg_postinst() {
	elisp-site-regen
}


pkg_postrm() {
	elisp-site-regen
}
