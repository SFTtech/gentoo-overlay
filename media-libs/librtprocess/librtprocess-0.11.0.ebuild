# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Algorithms for RAW processing from RawTherapee"
HOMEPAGE="https://github.com/CarVac/librtprocess/"
SRC_URI="https://github.com/CarVac/librtprocess/archive/refs/tags/0.11.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-11-build-fix.patch
	"${FILESDIR}"/${P}-fix-missing-include.patch
)

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

