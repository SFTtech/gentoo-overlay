# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_{6,7},3_{3,4,5,6,7}} pypy )

inherit distutils-r1

DESCRIPTION="Use requests to talk HTTP via a UNIX domain socket"
HOMEPAGE="https://pypi.python.org/pypi/requests-unixsocket https://github.com/msabramo/requests-unixsocket"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=""
DEPEND="
dev-python/pbr[${PYTHON_USEDEP}]
dev-python/setuptools[${PYTHON_USEDEP}]
dev-python/requests[${PYTHON_USEDEP}]
dev-python/urllib3[${PYTHON_USEDEP}]
"
