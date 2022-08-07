# Copyright 2022-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2 or later

EAPI=7

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/tobhe/${PN}.git"
fi

inherit cmake ${SCM}

DESCRIPTION="a serial terminal emulator from OpenBSD"
HOMEPAGE="https://github.com/tobhe/opencu"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/tobhe/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="ISC"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND=""
DEPEND="${RDEPEND}"
