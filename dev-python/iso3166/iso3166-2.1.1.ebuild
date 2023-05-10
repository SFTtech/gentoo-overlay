# Copyright 2023-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/deactivated/python-iso3166.git"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="Standalone ISO 3166-1 country definitions"
HOMEPAGE="https://github.com/deactivated/python-iso3166"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="MIT"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND=""
DEPEND="
${RDEPEND}"
