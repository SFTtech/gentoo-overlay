# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib meson

DESCRIPTION="Standalone Xwayland package"
HOMEPAGE="https://xorg.freedesktop.org/"
SRC_URI="https://xorg.freedesktop.org/archive/individual/xserver/xwayland-${PV}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="${IUSE_SERVERS} debug ipv6 libressl test unwind xcsecurity"
RESTRICT="!test? ( test )"


CDEPEND="
	media-libs/libglvnd[X]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	>=x11-apps/iceauth-1.0.2
	>=x11-apps/rgb-1.0.3
	>=x11-apps/xauth-1.0.3
	x11-apps/xkbcomp
	>=x11-libs/libdrm-2.4.89
	>=x11-libs/libpciaccess-0.12.901
	>=x11-libs/libXau-1.0.4
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXfont2-2.0.1
	>=x11-libs/libxkbfile-1.0.4
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	>=x11-misc/xbitmaps-1.0.1
	>=x11-misc/xkeyboard-config-2.4.1-r3
	>=x11-libs/libX11-1.1.5
	>=x11-libs/libXext-1.0.5
	>=media-libs/mesa-18[X(+),egl,gbm]
	>=media-libs/libepoxy-1.5.4[X,egl(+)]
	unwind? ( sys-libs/libunwind )
	>=dev-libs/wayland-1.3.0
	>=media-libs/libepoxy-1.5.4[egl(+)]
	>=dev-libs/wayland-protocols-1.18
	>=x11-apps/xinit-1.3.3-r1
"
DEPEND="${CDEPEND}
	>=x11-base/xorg-proto-2018.4
	>=x11-libs/xtrans-1.3.5
"
RDEPEND="${CDEPEND}
	!!x11-base/xorg-server[wayland]
"

BDEPEND="
	sys-devel/flex
	dev-util/wayland-scanner
"

src_install() {
	meson_src_install
	rm "${D}/usr/share/man/man1/Xserver.1"
	rm "${D}/usr/lib64/xorg/protocol.txt"
}
