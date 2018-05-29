# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{3,4,5,6} )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/snare/${PN}.git"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="Debugger frontent for hackers"
HOMEPAGE="https://github.com/snare/voltron"
SRC_URI=""

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
else
	SRC_URI="https://github.com/snare/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
dev-python/blessed[${PYTHON_USEDEP}]
dev-python/flask-restful[${PYTHON_USEDEP}]
dev-python/flask[${PYTHON_USEDEP}]
dev-python/pygments[${PYTHON_USEDEP}]
dev-python/pysigset[${PYTHON_USEDEP}]
dev-python/requests-unixsocket[${PYTHON_USEDEP}]
dev-python/requests[${PYTHON_USEDEP}]
dev-python/scruffington[${PYTHON_USEDEP}]
dev-python/setuptools[${PYTHON_USEDEP}]
dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/no-gdb-check.patch"
)
