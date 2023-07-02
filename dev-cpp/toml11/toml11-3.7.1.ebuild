# Copyright 2022-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2 or later

EAPI=8

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ToruNiina/toml11.git"
fi

inherit cmake ${SCM}

DESCRIPTION="TOML for Modern C++"
HOMEPAGE="https://github.com/ToruNiina/toml11.git"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="
https://github.com/ToruNiina/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="MIT"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-Dtoml11_INSTALL=ON
	)

	cmake_src_configure
}
