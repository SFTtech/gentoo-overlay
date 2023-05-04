# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


MY_PN="xr-hardware"
DESCRIPTION="XR hardware udev rules"
HOMEPAGE="https://gitlab.freedesktop.org/monado/utilities/xr-hardware"
SRC_URI="https://gitlab.freedesktop.org/monado/utilities/xr-hardware/-/archive/${PV}/xr-hardware-${PV}.tar.bz2"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
