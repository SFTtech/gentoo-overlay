# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A free astronomical image processing software"
HOMEPAGE="https://www.siril.org/"
SRC_URI="https://gitlab.com/free-astro/siril/-/archive/${PV/_/-}/${PN}-${PV/_/-}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="curl ffmpeg gnuplot heif jpeg openmp png raw tiff wcs"

DEPEND="
	>=dev-libs/json-glib-1.2.6
	>=dev-libs/libconfig-1.4[cxx]
	media-gfx/exiv2
	media-libs/librtprocess:0=
	>=media-libs/opencv-4.4.0:=
	sci-libs/cfitsio
	sci-libs/fftw:3.0=
	sci-libs/gsl:=
	>=x11-libs/gtk+-3.20.0:3
	curl? ( net-misc/curl )
	ffmpeg? ( media-video/ffmpeg:= )
	gnuplot? ( sci-visualization/gnuplot )
	heif? ( media-libs/libheif )
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng )
	raw? ( media-libs/libraw )
	tiff? ( media-libs/tiff )
	wcs? ( >=sci-astronomy/wcslib-7.7 )
	"
RDEPEND="${DEPEND}"

DOCS=( README.md NEWS ChangeLog )

S="${WORKDIR}/${PN}-${PV/_/-}"

src_configure() {
	local emesonargs=(
		$(meson_use openmp)
		$(usex curl -Denable-libcurl=yes -Denable-libcurl=no)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
