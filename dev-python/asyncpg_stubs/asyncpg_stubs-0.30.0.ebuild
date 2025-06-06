# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Typing stubs for asyncpg"
HOMEPAGE="https://pypi.org/project/asyncpg-stubs/ https://github.com/bryanforbes/asyncpg-stubs"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
