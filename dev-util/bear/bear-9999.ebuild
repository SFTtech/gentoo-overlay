# Copyright 2019-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2 or later

EAPI=6

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/rizsotto/${PN}"
fi

CMAKE_MIN_VERSION=2.8.0
inherit cmake-utils ${SCM}

DESCRIPTION="generates a compilation database for clang tooling"
HOMEPAGE="https://github.com/rizsotto/Bear"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/rizsotto/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND="
>=dev-lang/python-3.2
"
DEPEND="${RDEPEND}"
