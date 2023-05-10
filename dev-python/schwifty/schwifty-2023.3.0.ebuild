# Copyright 2023-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/mdomke/schwifty.git"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="IBAN parsing and validation"
HOMEPAGE="https://github.com/mdomke/schwifty"

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

RDEPEND="
dev-python/iso3166[${PYTHON_USEDEP}]
dev-python/pycountry[${PYTHON_USEDEP}]
"
DEPEND="
${RDEPEND}"
