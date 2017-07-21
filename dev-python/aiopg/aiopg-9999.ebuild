# Copyright 2016-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5} )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/aio-libs/${PN}.git https://github.com/aio-libs/${PN}.git"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="postgresql access from asyncio"
HOMEPAGE="https://github.com/aio-libs/aiopg"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/aio-libs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
fi


LICENSE="BSD-2"
SLOT="0"
IUSE="debug"
REQUIRED_USE=""

RDEPEND="
dev-python/psycopg
"
DEPEND="${RDEPEND}"
