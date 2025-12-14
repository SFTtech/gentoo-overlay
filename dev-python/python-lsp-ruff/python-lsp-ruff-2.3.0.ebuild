# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Ruff linting plugin for the Python LSP Server"
HOMEPAGE="
	https://github.com/python-lsp/python-lsp-ruff/
	https://pypi.org/project/python-lsp-ruff/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-util/ruff-0.2.0
	dev-python/cattrs[${PYTHON_USEDEP}]
	dev-python/python-lsp-server[${PYTHON_USEDEP}]
	>=dev-python/lsprotocol-2023.0.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
