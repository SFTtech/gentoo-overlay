# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Boilerplate framework for plugin, config and log management"
HOMEPAGE="https://pypi.python.org/pypi/scruffington https://github.com/snare/scruffy"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"  # pypi package is broken...
SRC_URI="https://github.com/snare/scruffy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
dev-python/six[${PYTHON_USEDEP}]
dev-python/pyyaml[${PYTHON_USEDEP}]
"

S=${WORKDIR}/scruffy-${PV}
