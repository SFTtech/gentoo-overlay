# Copyright 2015-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5} )

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
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="test"
REQUIRED_USE=""

RDEPEND="
	dev-python/ply[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# packaged patches:
	#PATCHES=(
	#)

	# user patches:
	eapply_user
}

python_test() {
	nosetests --verbose || die
}
