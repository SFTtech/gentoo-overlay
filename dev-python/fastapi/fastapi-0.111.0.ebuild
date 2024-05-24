# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1 pypi

DESCRIPTION="High performance, easy to learn, fast to code, ready for production"
HOMEPAGE="https://fastapi.tiangolo.com/ https://github.com/tiangolo/fastapi"

LICENSE="MIT"
SLOT=0
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

RDEPEND="
	<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]
	<dev-python/starlette-0.38[${PYTHON_USEDEP}]
"
