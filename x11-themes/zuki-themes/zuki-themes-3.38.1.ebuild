# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_PV="$(ver_rs 2 -)"
DESCRIPTION="Zuki themes for GTK, gnome-shell and more"
HOMEPAGE="https://github.com/lassekongo83/zuki-themes"
SRC_URI="https://github.com/lassekongo83/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/sassc
	x11-themes/gnome-themes-standard
	x11-themes/gtk-engines-murrine
"
DEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"
