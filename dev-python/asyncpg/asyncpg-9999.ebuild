# Copyright 2016-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/MagicStack/${PN}.git"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="fast PostgreSQL Database Client Library for Python/asyncio"
HOMEPAGE="https://github.com/MagicStack/asyncpg"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/MagicStack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug"
REQUIRED_USE=""

RDEPEND="
dev-db/postgresql
"
DEPEND="
dev-python/cython
${RDEPEND}"
