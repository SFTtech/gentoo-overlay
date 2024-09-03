# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12})

#MY_PN="python-lsp-ruff"

inherit distutils-r1

DESCRIPTION="Ruff plugin for the Python LSP Server"
HOMEPAGE="
	https://github.com/python-lsp/python-lsp-ruff
	https://pypi.org/project/python-lsp-ruff
"
SRC_URI="
	https://github.com/python-lsp/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
#S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/cattrs[$PYTHON_USEDEP]
	dev-python/python-lsp-server[$PYTHON_USEDEP]
	dev-python/lsprotocol[$PYTHON_USEDEP]
	dev-python/tomli[$PYTHON_USEDEP]
	dev-util/ruff
"

distutils_enable_tests pytest
