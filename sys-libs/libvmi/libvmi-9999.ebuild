# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Id$

EAPI=5

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/libvmi/libvmi.git https://github.com/libvmi/libvmi.git"
fi

inherit autotools ${SCM}

MY_PV="${PV/_/-}"

DESCRIPTION="virtual machine introspection toolkit"
HOMEPAGE="http://libvmi.com/ https://github.com/libvmi/libvmi"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/libvmi/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm ~arm64"
fi

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug xen kvm"
REQUIRED_USE="
|| ( xen kvm )
"

DEPEND="
virtual/yacc
sys-devel/flex
>=dev-libs/glib-2.16

xen? (
	app-emulation/xen-tools
)
kvm? (
	app-emulation/libvirt
)
"
RDEPEND="${DEPEND}"

src_prepare() {
	_elibtoolize
	eaclocal
	eautoheader
	eautomake
	eautoconf

	epatch_user
}

src_configure() {
	econf \
		$(use_enable xen) \
		$(use_enable kvm)
}
