# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python3_{11..14} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Boilerplate framework for plugin, config and log management"
HOMEPAGE="https://pypi.python.org/pypi/scruffington https://github.com/snare/scruffy"
#SRC_URI="https://github.com/snare/scruffy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
dev-python/six[${PYTHON_USEDEP}]
dev-python/pyyaml[${PYTHON_USEDEP}]
"

S=${WORKDIR}/scruffy-${PV}
