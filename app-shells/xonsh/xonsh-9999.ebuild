# Copyright 2015-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_4 )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/scopatz/${PN}.git https://github.com/scopatz/${PN}.git"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="pythonic shell"
HOMEPAGE="http://xonsh.org https://github.com/scopatz/xonsh"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
else
	SRC_URI="https://github.com/scopatz/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi


LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
REQUIRED_USE=""

RDEPEND="
dev-python/ply
"
DEPEND="${RDEPEND}"

src_prepare() {
	# packaged patches:
	#PATCHES=(
	#)

	# user patches:
	epatch_user
}
