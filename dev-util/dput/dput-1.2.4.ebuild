# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Debian package upload tool"
HOMEPAGE="
https://salsa.debian.org/debian/dput/
https://packages.debian.org/source/sid/dput
"
SRC_URI="
	https://salsa.debian.org/debian/dput/-/archive/release/${PV}/dput-release-${PV}.tar.bz2
		-> ${P}.gh.tar.bz2
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
dev-python/python-debian[${PYTHON_USEDEP}]
app-crypt/gpgme[python,${PYTHON_USEDEP}]
"
BDEPEND="
"

S="${WORKDIR}/dput-release-${PV}"

PATCHES=(
    "${FILESDIR}/executable-names.patch"
    "${FILESDIR}/pyxdg-6-compat.patch"
)
