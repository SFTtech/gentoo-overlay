# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

if [[ ${PV} == *_rc* ]] ; then
	MY_PV=${PV/_rc/-rc}
fi

DESCRIPTION="a free astronomical image processing software"
HOMEPAGE="https://www.siril.org/"
SRC_URI="https://free-astro.org/download/${PN}-${MY_PV}.tar.bz2"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libav"

DEPEND="
	dev-libs/libconfig[cxx]
	media-libs/giflib
	media-libs/libpng:0=
	media-libs/libraw:=
	media-libs/opencv:=
	media-libs/tiff:0=
	media-libs/librtprocess:0=
	sci-libs/cfitsio
	sci-libs/fftw:3.0=
	sci-libs/gsl
	virtual/jpeg:0
	>=x11-libs/gtk+-3.6.0:3
	libav? ( media-video/libav:= )
	!libav? ( media-video/ffmpeg:= )
	"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
}


