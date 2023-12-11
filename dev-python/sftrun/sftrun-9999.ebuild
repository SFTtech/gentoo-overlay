# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

PYTHON_COMPAT=( python3_{10,11,12} )
DISTUTILS_USE_PEP517=setuptools

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/SFTtech/${PN}.git"
fi

inherit distutils-r1 $SCM

DESCRIPTION="shell-like subprocess execution, piping and redirection for Python"
HOMEPAGE="https://github.com/SFTtech/sftrun https://pypi.python.org/pypi/sftrun"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	SRC_URI="https://github.com/SFTtech/sftrun/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=""
