# Copyright 2019-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2 or later

EAPI=7

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/MaskRay/${PN}"
fi

inherit cmake ${SCM}

DESCRIPTION="C/C++/ObjC language server protocol implementation"
HOMEPAGE="https://github.com/MaskRay/ccls"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/MaskRay/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND="
sys-devel/clang:=
sys-devel/llvm:=
dev-libs/rapidjson
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DCLANG_LINK_CLANG_DYLIB=1
	)
	cmake_src_configure
}
