# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/kliment/${PN}.git https://github.com/kliment/${PN}.git"
fi

inherit distutils-r1 ${SCM}


DESCRIPTION="GUI interface for 3D printing on RepRap and other printers"
HOMEPAGE="https://github.com/kliment/Printrun"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/kliment/Printrun/archive/${P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/dbus-python
	dev-python/numpy
	dev-python/pycairo
	dev-python/pyglet
	dev-python/pyserial
	dev-python/wxpython
	media-gfx/cairosvg
"
RDEPEND="${DEPEND}"

#PATCHES=(
#	"${FILESDIR}/printrun-no-py-in-binaries.patch"
#)
