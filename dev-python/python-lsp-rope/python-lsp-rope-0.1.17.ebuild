# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13})

MY_PN="pylsp-rope"

inherit distutils-r1

DESCRIPTION="Mypy plugin for the Python LSP Server"
HOMEPAGE="
	https://github.com/python-lsp/pylsp-mypy
	https://pypi.org/project/pylsp-mypy/
"
SRC_URI="
	https://github.com/python-rope/${MY_PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/python-lsp-server[${PYTHON_USEDEP}]
	dev-python/rope[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
