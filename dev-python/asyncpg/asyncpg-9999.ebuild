# Copyright 2016-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/MagicStack/${PN}.git"
fi

inherit distutils-r1 pypi ${SCM}

DESCRIPTION="fast PostgreSQL Database Client Library for Python/asyncio"
HOMEPAGE="https://github.com/MagicStack/asyncpg"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	# don't use the github tarball, it does not contain the "great" git submodule
	#SRC_URI=  use pypi.eclass
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug"
REQUIRED_USE=""

RDEPEND="
dev-db/postgresql:*
"
DEPEND="
dev-python/cython
${RDEPEND}"
