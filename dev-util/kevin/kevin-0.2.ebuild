# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_{5,6} )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/SFTtech/${PN}.git https://github.com/SFTtech/${PN}.git"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="Kevin-CI: simple-stupid self-hostable continuous integration service"
HOMEPAGE="https://github.com/SFTtech/kevin"
SRC_URI=""

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/SFTtech/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE=""

DEPEND="
dev-python/requests[${PYTHON_USEDEP}]
www-servers/tornado[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
