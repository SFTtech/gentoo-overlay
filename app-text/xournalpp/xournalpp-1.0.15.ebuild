# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xournalpp/xournalpp"
	unset SRC_URI
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xournalpp/xournalpp/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="An application for notetaking, sketching, and keeping a journal using a stylus"
HOMEPAGE="https://github.com/xournalpp/xournalpp"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	x11-libs/gtk+:3
	dev-libs/glib
	app-text/poppler:=[cairo,introspection]
	dev-libs/libxml2
	media-libs/portaudio[cxx]
	media-libs/libsndfile
	dev-lang/lua
	dev-libs/libzip
	dev-texlive/texlive-pictures
"
RDEPEND="${RDEPEND}"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

