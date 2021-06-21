# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2 vala

DESCRIPTION="Set of programs to inspect and build Windows Installer (.MSI) files"
HOMEPAGE="https://wiki.gnome.org/msitools"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/${PV}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+introspection static vala"
REQUIRED_USE="
	vala? ( introspection )
"

RDEPEND="
	>=app-arch/gcab-0.4
	introspection? ( >=dev-libs/gobject-introspection-0.10.8 )
"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection-common
	dev-libs/vala-common
	gnome-extra/libgsf
	>=dev-util/gtk-doc-am-1.13
	>=virtual/pkgconfig-0-r1
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	gnome2_src_prepare
}

src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(use_enable static) \
		$(use_enable introspection)
}
