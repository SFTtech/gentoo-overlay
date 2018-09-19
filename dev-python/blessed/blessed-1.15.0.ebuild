# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_{6,7},3_{3,4,5,6}} pypy )

inherit distutils-r1

DESCRIPTION="Simplified curses wrapper"
HOMEPAGE="https://pypi.python.org/pypi/blessed https://github.com/jquast/blessed"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
dev-python/wcwidth[${PYTHON_USEDEP}]
dev-python/six[${PYTHON_USEDEP}]
"
