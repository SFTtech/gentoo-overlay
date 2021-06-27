# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson vala

DESCRIPTION="Set of programs to inspect and build Windows Installer (.MSI) files"
HOMEPAGE="https://wiki.gnome.org/msitools"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+introspection"
REQUIRED_USE="
	introspection
"

BDEPEND="
    dev-lang/perl
	sys-devel/bison
	dev-util/bats
"

RDEPEND="
	introspection? ( >=dev-libs/gobject-introspection-0.10.8 )
"
DEPEND="${RDEPEND}
	dev-libs/glib
	dev-libs/gobject-introspection-common
	dev-libs/vala-common
	gnome-extra/libgsf
	app-arch/gcab[vala]
	>=dev-util/gtk-doc-am-1.13
	>=virtual/pkgconfig-0-r1
"

PATCHES=(
	"${FILESDIR}"/${P}-bats-dependency.patch
)

src_prepare() {
	vala_src_prepare
	default
}

src_configure() {
        local emesonargs=(
                $(meson_use introspection)
        )
        meson_src_configure
}
